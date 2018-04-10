require 'rails_helper'

RSpec.describe 'root controller', type: :request do
  context '#show' do
    context "when not logged in" do
      it "redirects to login page" do
        get '/'
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    context "when logged in" do
      before do
        login_as(create(:user, role: "admin"), :scope => :user)
      end

      it "renders the root page" do
        get '/'
        expect(response.body).to include("Welcome to SQL Assess")
      end
    end
  end
end
