require "rails_helper"

RSpec.feature "Requirement 6: Challenge edit", :type => :feature do
  let!(:challenge) { create(:challenge) }
  before do
    login_as(create(:user, role: "admin"), :scope => :user)
  end

  scenario "it updates the challenge" do
    visit "/challenges/#{challenge.id}"

    click_link "Edit"

    fill_in "Title",	with: "Updated title"

    click_button "Update"

    expect(page).to have_selector('.alert.alert-success > .container', exact_text: "Successfully Updated")
    expect(page).to have_text("Updated title")
  end
end
