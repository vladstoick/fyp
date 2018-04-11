require "rails_helper"

RSpec.feature "Requirement 9: Schema view", :type => :feature do
  let!(:challenge) { create(:challenge) }
  before do
    login_as(create(:user, role: "student"), :scope => :user)
  end

  scenario "show the sql schema" do
    visit "/challenges/#{challenge.id}/submissions/new"

    expect(page).to have_text(challenge.sql_schema)
  end

  scenario "show the schema as table" do
    visit "/challenges/#{challenge.id}/submissions/new"

    expect(page).to have_selector('html  > body > .container > h3', exact_text: "t1")
    expect(page).to have_selector('html  > body > .container > .table.table-bordered > thead > tr > th', exact_text: "id int(11)")
  end
end
