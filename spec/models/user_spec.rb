require "rails_helper"

describe User do
  subject { build(:user) }

  it { should validate_inclusion_of(:role).in_array(%w[admin student]) }

  context "#admin?" do
    before do
      subject.role = role
    end

    context 'as an admin' do
      let(:role) { 'admin' }

      it "returns true" do
        expect(subject.admin?).to eq(true)
      end
    end

    context 'as an student' do
      let(:role) { 'student' }

      it "returns true" do
        expect(subject.admin?).to eq(false)
      end
    end
  end
end
