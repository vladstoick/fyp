require "rails_helper"

RSpec.feature "Requirement 10: hints", :type => :feature do
  let!(:challenge) { create(:challenge) }
  before do
    login_as(create(:user, role: "student"), :scope => :user)
  end

  context "with no compilation errors" do
    context "but wrong query" do
      scenario "it shows hints" do
        visit "challenges/#{challenge.id}/submissions/new"

        fill_in "Sql query",	with: "SELECT 20 from t1;"

        click_button "Submit"

        expect(page.current_path).to eq("/challenges/#{challenge.id}/submissions/#{Submission.last.id}")
        expect(page).to have_text("Successfully submitted!")
        expect(page).to have_text("Check what columns you are selecting.")
      end
    end
  end
end
