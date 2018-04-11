require "rails_helper"

RSpec.feature "Requirement R2: Authentication", :type => :feature do
  let!(:user) { create(:user, email: "test@gmail.com", password: "test123") }

  context "signin" do
    context "with right details" do
      it "signs in" do
        visit "/users/sign_in"

        fill_in "Email",	with: "test@gmail.com"
        fill_in "Password",	with: "test123"

        click_button "Log in"

        expect(page).to have_text("Signed in successfully.")
        expect(page).to have_text("test@gmail.com")
      end
    end

    context "with wrong details" do
      it "shos an error" do
        visit "/users/sign_in"

        fill_in "Email",	with: "test@gmail.com"
        fill_in "Password",	with: "wrongpswd"

        click_button "Log in"

        expect(page).to have_selector('.alert.alert-warning > .container', exact_text: "Invalid Email or password.")
      end
    end
  end

  context "sign out" do
    before do
      login_as(user, :scope => :user)
    end

    it "logs out" do
      visit "/"
      expect(page).to have_text("test@gmail.com")
      click_link "Sign out", visible: false
      expect(page).to_not have_text("test@gmail.com")
      expect(page.current_path).to eq("/users/sign_in")
    end
  end

  context "edit account" do
    before do
      login_as(user, :scope => :user)
    end

    it 'should update the user' do
      visit('/users/edit')

      expect(page).to have_text("test@gmail.com")

      fill_in('user[email]', :with => 'test@example.com')
      fill_in('user[current_password]', :with => 'test123')

      click_button('Update')

      expect(page).to_not have_text("test@gmail.com")
      expect(page).to have_text("test@example.com")
      expect(page).to have_selector('.alert.alert-secondary > .container', exact_text: "Your account has been updated successfully.")
    end
  end
end
