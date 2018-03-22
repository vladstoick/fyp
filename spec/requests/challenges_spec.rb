require 'rails_helper'

RSpec.describe ChallengesController, type: :request do


  context '#show' do
    context "requesting a challenge that doesn't exit" do
      it 'returns a 404' do
        get '/challenges/ab'
        expect(response.status).to eq(404)
      end
    end
  end
end
