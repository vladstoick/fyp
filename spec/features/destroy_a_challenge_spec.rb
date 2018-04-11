require "rails_helper"

RSpec.feature "Requirement 7: Challenge destroy", :type => :feature do
  let!(:challenge) { create(:challenge) }

  before do
    login_as(create(:user, role: "admin"), :scope => :user)
  end

  scenario "it updates the challenge" do
    visit "/challenges/#{challenge.id}"

    click_button "Destroy"

    expect(page).to have_selector('.alert.alert-success > .container', exact_text: "Sucesfully destroyed")
    expect(page).to_not have_text(challenge.title)
  end
end
