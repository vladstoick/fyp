require "rails_helper"

RSpec.feature "Requirement 8: Submitting solutions", :type => :feature do
  let!(:challenge) { create(:challenge) }
  before do
    login_as(create(:user, role: "student"), :scope => :user)
  end

  context "with compilation errors" do
    scenario "it displays the errors" do
      visit "challenges/#{challenge.id}/submissions/new"

      fill_in "Sql query",	with: "SELECT * from abc;"

      click_button "Submit"

      expect(page.current_path).to eq("/challenges/#{challenge.id}/submissions")
      expect(page).to have_text(".abc' doesn't exist")
    end
  end

  context "with no compilation errors" do
    scenario "it creates the submission" do
      visit "challenges/#{challenge.id}/submissions/new"

      fill_in "Sql query",	with: "SELECT * from t1"

      click_button "Submit"

      expect(page.current_path).to eq("/challenges/#{challenge.id}/submissions/#{Submission.last.id}")
      expect(page).to have_text("Successfully submitted!")
      expect(page).to have_text("Your solutions is correct")
    end
  end
end
