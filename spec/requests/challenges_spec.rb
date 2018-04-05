require 'rails_helper'

RSpec.describe ChallengesController, type: :request do
  context '#show' do
    context "when logged in" do
      before do
        login_as(create(:user, role: "admin"), :scope => :user)
      end

      context "requesting a challenge that doesn't exit" do
        it 'returns a 404' do
          get '/challenges/ab'

          expect(response.status).to eq(404)
        end
      end
    end
  end
end
