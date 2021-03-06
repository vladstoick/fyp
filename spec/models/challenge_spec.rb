require "rails_helper"

describe Challenge do
  subject { build(:challenge) }
  it { should have_many(:submissions) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:sql_schema) }
  it { should validate_presence_of(:sql_correct_query) }
  it { should validate_presence_of(:sql_seed) }

  context "#best_submissions" do
    subject { create(:challenge) }
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }

    before do
      create(:submission, user: user1, challenge: subject).tap do |sub|
        sub.update_attribute(:grade, 55)
      end

      create(:submission, user: user1, challenge: subject).tap do |sub|
        sub.update_attribute(:grade, 60)
      end

      create(:submission, user: user1, challenge: subject).tap do |sub|
        sub.update_attribute(:grade, 48)
      end

      create(:submission, user: user2, challenge: subject).tap do |sub|
        sub.update_attribute(:grade, 48)
      end

      create(:submission, user: user2, challenge: subject).tap do |sub|
        sub.update_attribute(:grade, 44)
      end
    end

    it "returns the correct results" do
      result = subject.best_submissions.map do |sub|
        [sub.user_id, sub.max_grade]
      end.to_h

      expect(result).to eq({
        user1.id => 60,
        user2.id => 48,
      })
    end
  end

  context "#compile_sql" do
    context "with no errors" do
      it "saves metadata" do
        expect(subject).to be_valid
        expect(subject.metadata).to eq([
          {
            "name" => "t1",
            "columns" => [{ "name" => "id", "type" => "int(11)" }],
            "data"=>[{ "id" => 1 }],
          }
        ])
      end
    end

    context "with errors in the schema sql" do
      before do
        subject.sql_schema = "CREATE TABLE t1(id sda)"
      end

      it "adds an appropiate error" do
        expect(subject).to_not be_valid
        expect(subject.errors.count).to eq(1)
        expect(subject.errors[:sql_schema].count).to eq(1)
        expect(subject.errors[:sql_schema]).to eq([
          "You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'sda)' at line 1"
        ])
      end
    end

    context "with errors in the seed sql" do
      before do
        subject.sql_seed = "INSERT INTO t1(id sda) VALUES(1)"
      end

      it "adds an appropiate error" do
        expect(subject).to_not be_valid
        expect(subject.errors.count).to eq(1)
        expect(subject.errors[:sql_seed].count).to eq(1)
        expect(subject.errors[:sql_seed]).to eq([
          "You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'sda) VALUES(1)' at line 1"
        ])
      end
    end

    context "with errors in the instructor sql" do
      before do
        subject.sql_correct_query = "SELECT a from t1"
      end

      it "adds an appropiate error" do
        expect(subject).to_not be_valid
        expect(subject.errors.count).to eq(1)
        expect(subject.errors[:sql_correct_query].count).to eq(1)
        expect(subject.errors[:sql_correct_query]).to eq([
          "Unknown column 'a' in 'field list'"
        ])
      end
    end

    context "with parsing errors in the query sql" do
      before do
        subject.sql_correct_query = "SELECT ROUND(id, 2) from t1"
      end

      it "adds an appropiate error" do
        expect(subject).to_not be_valid
        expect(subject.errors.count).to eq(1)
        expect(subject.errors[:sql_correct_query].count).to eq(1)
        expect(subject.errors[:sql_correct_query]).to eq([
          "Cannot canonicalize query"
        ])
      end
    end
  end
end
