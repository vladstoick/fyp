require "rails_helper"

RSpec.feature "Requirement R3: Permissions", :type => :feature do
  let!(:user) { create(:user, email: "test@gmail.com", password: "test123") }

  context "as an admin" do
    before do
      login_as(create(:user, role: "admin"), :scope => :user)
    end

    scenario "I can create challenges" do
      visit "/challenges/new"
      expect(page.status_code).to eq(200)
      expect(page.body).to include("New Challenge")
    end
  end

  context "as a student" do
    before do
      login_as(create(:user, role: "student"), :scope => :user)
    end

    scenario "I can't create challenges" do
      visit "/challenges/new"
      expect(page.status_code).to eq(401)
      expect(page.body).to eq("Not Authorized")
    end
  end
end
