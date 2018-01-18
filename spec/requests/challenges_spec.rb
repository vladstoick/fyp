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
  # it 'creates a Widget and redirects to the Widget's page' do
  #   get '/challenge'
  #   expect(response).to render_template(:new)

  #   post '/widgets', :widget => {:name => 'My Widget'}

  #   expect(response).to redirect_to(assigns(:widget))
  #   follow_redirect!

  #   expect(response).to render_template(:show)
  #   expect(response.body).to include('Widget was successfully created.')
  # end

  # it 'does not render a different template' do
  #   get '/widgets/new'
  #   expect(response).to_not render_template(:show)
  # end
end
