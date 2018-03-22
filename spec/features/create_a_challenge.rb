require "rails_helper"

RSpec.feature "Widget management", :type => :feature do
  before do
    login_as(create(:user, role: "admin"), :scope => :user)
  end

  context "with no errors" do
    it "creates the challenge" do
      visit "/challenges/new"

      fill_in "Title",	with: "Challenge 1"
      fill_in "Content",	with: "Challenge 1 content"
      fill_in "Sql schema",	with: "CREATE TABLE t1(id integer);"
      fill_in "Sql seed",	with: "INSERT INTO t1(id) VALUES (1), (2);"
      fill_in "Sql correct query",	with: "SELECT * FROM t1"

      click_button "Create"

      expect(page).to have_text("Successfully created")

      expect(page).to have_text("CREATE TABLE t1(id integer);")
      expect(page).to have_text("INSERT INTO t1(id) VALUES (1), (2);")
      expect(page).to have_text("SELECT * FROM t1")
    end
  end
end
