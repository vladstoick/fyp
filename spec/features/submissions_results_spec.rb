require "rails_helper"

RSpec.feature "Requirement 12: Submissions results", :type => :feature do
  let(:challenge) { create(:challenge) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }

  before do
    create(:submission, user: user1, challenge: challenge).tap do |sub|
      sub.update_attribute(:grade, 55)
    end

    create(:submission, user: user1, challenge: challenge).tap do |sub|
      sub.update_attribute(:grade, 60)
    end

    create(:submission, user: user1, challenge: challenge).tap do |sub|
      sub.update_attribute(:grade, 48)
    end

    create(:submission, user: user2, challenge: challenge).tap do |sub|
      sub.update_attribute(:grade, 48)
    end

    create(:submission, user: user2, challenge: challenge).tap do |sub|
      sub.update_attribute(:grade, 44)
    end

    login_as(create(:user, role: "admin"), :scope => :user)
  end

  context "tabular view" do
    it 'should show the results' do
      visit("/challenges/#{challenge.id}")
      click_link('View Submissions')

      expect(page).to have_selector(
        'html  > body > .container > .table > tbody > tr:nth-child(1)',
        exact_text: "#{user1.email} 55.0 View submission"
      )

      expect(page).to have_selector(
        'html  > body > .container > .table > tbody > tr:nth-child(2)',
        exact_text: "#{user1.email} 60.0 View submission"
      )

      expect(page).to have_selector(
        'html  > body > .container > .table > tbody > tr:nth-child(3)',
        exact_text: "#{user1.email} 48.0 View submission"
      )

      expect(page).to have_selector(
        'html  > body > .container > .table > tbody > tr:nth-child(4)',
        exact_text: "#{user2.email} 48.0 View submission"
      )

      expect(page).to have_selector(
        'html  > body > .container > .table > tbody > tr:nth-child(5)',
        exact_text: "#{user2.email} 44.0 View submission"
      )
    end
  end

  context "downloading csv" do
    it "downloads the correct csv" do
      visit("/challenges/#{challenge.id}")
      click_link('View Submissions')
      click_link('Download CSV')
      expect(page.response_headers["Content-Disposition"])
        .to eq("attachment; filename=\"grades_for_#{challenge.title}.csv\"")

      expect(CSV.parse(page.source)).to eq([
        ["email", "grade"],
        [user1.email, "60.0"],
        [user2.email, "48.0"]
      ])
    end
  end
end
