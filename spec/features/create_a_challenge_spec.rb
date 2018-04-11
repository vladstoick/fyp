require "rails_helper"

RSpec.feature "Requirement 4 and 5: Challenge creation", :type => :feature do
  before do
    login_as(create(:user, role: "admin"), :scope => :user)
  end

  context "Requirements 4: with no errors" do
    it "creates the challenge" do
      visit "/challenges/new"

      fill_in "Title",	with: "Challenge 1"
      fill_in "Content",	with: "Challenge 1 content"
      fill_in "Sql schema",	with: "CREATE TABLE t1(id integer);"
      fill_in "Sql seed",	with: "INSERT INTO t1(id) VALUES (1), (2);"
      fill_in "Sql correct query",	with: "SELECT * FROM t1"

      click_button "Create"

      expect(page.current_path).to eq("/challenges/#{Challenge.last.id}")
      expect(page).to have_text("Successfully created")

      expect(page).to have_text("CREATE TABLE t1(id integer);")
      expect(page).to have_text("INSERT INTO t1(id) VALUES (1), (2);")
      expect(page).to have_text("SELECT * FROM t1")
    end
  end

  context "Requirement 5: with errors" do
    it "creates the challenge" do
      visit "/challenges/new"

      fill_in "Title",	with: "Challenge 1"
      fill_in "Content",	with: "Challenge 1 content"
      fill_in "Sql schema",	with: "CREATE TABLE t1(id integer);"
      fill_in "Sql seed",	with: "INSERT INTO t1(id) VALUES (1), (2);"
      fill_in "Sql correct query",	with: "SELECT * FROM t2"

      click_button "Create"

      expect(page.current_path).to eq("/challenges")
      expect(page).to have_text(".t2' doesn't exist")
    end
  end
end
