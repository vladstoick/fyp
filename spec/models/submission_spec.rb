require "rails_helper"

describe Challenge do
  subject { build(:submission) }
  it { should belong_to(:challenge) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:sql_query) }

  context "#compile_sql" do
    context "with no errors" do
      it "saves metadata" do
        expect(subject).to be_valid
        expect(subject.success).to eq(true)
        expect(subject.grade).to eq(100)
        expect(subject.message).to be_a(String)
        expect(subject.metadata).to match({
          "instructor" => an_instance_of(Hash),
          "student" => an_instance_of(Hash)
        })
        expect(subject.attribute_grades).to be_a(Hash)
      end
    end

    context "with errors in the query sql" do
      before do
        subject.sql_query = "SELECT a from t1"
      end

      it "adds an appropiate error" do
        expect(subject).to_not be_valid
        expect(subject.errors.count).to eq(1)
        expect(subject.errors[:sql_query].count).to eq(1)
        expect(subject.errors[:sql_query]).to eq([
          "Unknown column 'a' in 'field list'"
        ])
      end
    end

    context "with parsing errors in the query sql" do
      before do
        subject.sql_query = "SELECT ROUND(id, 2) from t1"
      end

      it "adds an appropiate error" do
        expect(subject).to_not be_valid
        expect(subject.errors.count).to eq(1)
        expect(subject.errors[:sql_query].count).to eq(1)
        expect(subject.errors[:sql_query]).to eq([
          "Cannot canonicalize query"
        ])
      end
    end
  end
end
