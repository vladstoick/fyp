require 'rails_helper'

RSpec.describe 'challenges controller', type: :request do
  let!(:challenge) { create(:challenge, title: "Challenge for spec") }

  context "#index" do
    context 'when logged out' do
      it "redirects to login page" do
        get '/challenges'
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    context "when logged in" do
      context "as an admin" do
        before do
          login_as(create(:user, role: "admin"), :scope => :user)
        end

        it "returns 200" do
          get '/challenges'
          expect(response.status).to eq(200)
          expect(response.body).to include(challenge.title)
        end
      end
    end
  end

  context '#show' do
    context 'when logged out' do
      it "redirects to login page" do
        get '/challenges/ab'
        expect(response).to redirect_to "/users/sign_in"
      end
    end

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

      context "as an admin" do
        it "returns 200" do
          get "/challenges/#{challenge.id}"
          expect(response.status).to eq(200)
        end
      end

      context "as a student" do
        before do
          login_as(create(:user, role: "student"), :scope => :user)
        end

        it "returns 401" do
          get "/challenges/#{challenge.id}"
          expect(response.status).to eq(401)
        end
      end
    end
  end

  context '#edit' do
    context 'when logged out' do
      it "redirects to login page" do
        get '/challenges/ab/edit'
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    context "when logged in" do
      before do
        login_as(create(:user, role: "admin"), :scope => :user)
      end

      context "requesting a challenge that doesn't exit" do
        it 'returns a 404' do
          get '/challenges/ab/edit'

          expect(response.status).to eq(404)
        end
      end

      context "as an admin" do
        it "returns 200" do
          get "/challenges/#{challenge.id}/edit"
          expect(response.status).to eq(200)
        end
      end

      context "as a student" do
        before do
          login_as(create(:user, role: "student"), :scope => :user)
        end

        it "returns 401" do
          get "/challenges/#{challenge.id}/edit"
          expect(response.status).to eq(401)
        end
      end
    end
  end

  context '#new' do
    context 'when logged out' do
      it "redirects to login page" do
        get '/challenges/new'
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    context "when logged in" do
      before do
        login_as(create(:user, role: "admin"), :scope => :user)
      end

      context "as an admin" do
        it "returns 200" do
          get "/challenges/new"
          expect(response.status).to eq(200)
        end
      end

      context "as a student" do
        before do
          login_as(create(:user, role: "student"), :scope => :user)
        end

        it "returns 401" do
          get "/challenges/new"
          expect(response.status).to eq(401)
        end
      end
    end
  end

  context '#update' do
    context 'when logged out' do
      it "redirects to login page" do
        put '/challenges/ab'
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    context "when logged in" do
      before do
        login_as(create(:user, role: "admin"), :scope => :user)
      end

      context "requesting a challenge that doesn't exit" do
        it 'returns a 404' do
          put '/challenges/ab'

          expect(response.status).to eq(404)
        end
      end

      context "as an admin" do
        it "returns 302" do
          put "/challenges/#{challenge.id}", params: { challenge: { title: "Challenge 2"} }
          expect(response.status).to eq(302)
          expect(challenge.reload.title).to eq("Challenge 2")
        end

        context "with errors" do
          it "shows them" do
            put "/challenges/#{challenge.id}", params: { challenge: { sql_schema: "Challenge 2"} }
            expect(response.status).to eq(200)
            expect(response.body).to include("You have an error in your SQL syntax;")
          end
        end
      end

      context "as a student" do
        before do
          login_as(create(:user, role: "student"), :scope => :user)
        end

        it "returns 401" do
          put "/challenges/#{challenge.id}"
          expect(response.status).to eq(401)
        end
      end
    end
  end

  context '#destroy' do
    context 'when logged out' do
      it "redirects to login page" do
        delete '/challenges/ab'
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    context "when logged in" do
      before do
        login_as(create(:user, role: "admin"), :scope => :user)
      end

      context "requesting a challenge that doesn't exit" do
        it 'returns a 404' do
          delete '/challenges/ab'

          expect(response.status).to eq(404)
        end
      end

      context "as an admin" do
        it "returns 302" do
          delete "/challenges/#{challenge.id}"
          expect(Challenge.find_by_id(challenge.id)).to be_nil
          expect(response.status).to eq(302)
        end
      end

      context "as a student" do
        before do
          login_as(create(:user, role: "student"), :scope => :user)
        end

        it "returns 401" do
          delete "/challenges/#{challenge.id}"
          expect(response.status).to eq(401)
        end
      end
    end
  end

  context '#update' do
    context 'when logged out' do
      it "redirects to login page" do
        post '/challenges'
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    context "when logged in" do
      before do
        login_as(create(:user, role: "admin"), :scope => :user)
      end

      context "as an admin" do
        it "returns 200" do
          challenge = build(:challenge)
          post "/challenges", params: { challenge: JSON.parse(challenge.to_json) }
          expect(response.status).to eq(302)
          expect(response.body).to redirect_to "/challenges/#{Challenge.last.id}"
        end

        context "with errors" do
          it "displays them" do
            challenge = build(:challenge)
            challenge.title = ""
            post "/challenges", params: { challenge: JSON.parse(challenge.to_json) }
            expect(response.status).to eq(200)
            expect(response.body).to include("be blank")
          end
        end
      end

      context "as a student" do
        before do
          login_as(create(:user, role: "student"), :scope => :user)
        end

        it "returns 401" do
          post "/challenges"
          expect(response.status).to eq(401)
        end
      end
    end
  end
end
