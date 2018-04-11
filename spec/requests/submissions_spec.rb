require 'rails_helper'

RSpec.describe 'challenges controller', type: :request do
  let!(:challenge) { create(:challenge, title: "Challenge for spec") }

  context "#index" do
    context 'when logged out' do
      it "redirects to login page" do
        get "/challenges/#{challenge.id}/submissions"
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    context "when logged in" do
      context "as an admin" do
        before do
          login_as(create(:user, role: "admin"), :scope => :user)
        end

        context "for a challenge that doesn't exist" do
          it "returns 404" do
            get '/challenges/asadad/submissions'
            expect(response.status).to eq(404)
          end
        end

        context "for a challenge that exists" do
          it "returns 200" do
            get "/challenges/#{challenge.id}/submissions"
            expect(response.status).to eq(200)
            expect(response.body).to include(challenge.title)
          end
        end
      end

      context "as a student" do
        before do
          login_as(create(:user, role: "student"), :scope => :user)
        end

        it "returns 401" do
          get "/challenges/#{challenge.id}/submissions"
          expect(response.status).to eq(401)
        end
      end
    end
  end

  context '#show' do
    let!(:submission) { create(:submission, challenge: challenge, user: create(:user)) }

    context 'when logged out' do
      it "redirects to login page" do
        get "/challenges/#{challenge.id}/submissions/#{submission.id}"
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    context "when logged in" do
      before do
        login_as(create(:user, role: "admin"), :scope => :user)
      end

      context "requesting a submissions that doesn't exit" do
        it 'returns a 404' do
          get "/challenges/#{challenge.id}/submissions/sda"

          expect(response.status).to eq(404)
        end
      end

      context "as an admin" do
        it "returns 200" do
          get "/challenges/#{challenge.id}/submissions/#{submission.id}"
          expect(response.status).to eq(200)
        end
      end

      context "as a student" do
        let(:user) { create(:user, role: "student") }
        let(:submission2) { create(:submission, challenge: challenge, user: user)}
        before do
          login_as(user, :scope => :user)
        end

        context "someone's elses submission" do
          it "returns 401" do
            get "/challenges/#{challenge.id}/submissions/#{submission.id}"
            expect(response.status).to eq(401)
          end
        end

        context "students's submission" do
          it "returns 200" do
            get "/challenges/#{challenge.id}/submissions/#{submission2.id}"
            expect(response.status).to eq(200)
          end
        end
      end
    end
  end

  context '#report' do
    let!(:submission) { create(:submission, challenge: challenge, user: create(:user)) }

    context 'when logged out' do
      it "redirects to login page" do
        get "/challenges/#{challenge.id}/submissions/#{submission.id}/report"
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    context "when logged in" do
      before do
        login_as(create(:user, role: "admin"), :scope => :user)
      end

      context "requesting a submissions that doesn't exit" do
        it 'returns a 404' do
          get "/challenges/#{challenge.id}/submissions/sda/report"

          expect(response.status).to eq(404)
        end
      end

      context "as an admin" do
        it "returns 200" do
          get "/challenges/#{challenge.id}/submissions/#{submission.id}/report"
          expect(response.status).to eq(200)
        end
      end

      context "as a student" do
        let(:user) { create(:user, role: "student") }
        let(:submission2) { create(:submission, challenge: challenge, user: user)}
        before do
          login_as(user, :scope => :user)
        end

        context "someone's elses submission" do
          it "returns 401" do
            get "/challenges/#{challenge.id}/submissions/#{submission.id}/report"
            expect(response.status).to eq(401)
          end
        end

        context "students's submission" do
          it "returns 401" do
            get "/challenges/#{challenge.id}/submissions/#{submission2.id}/report"
            expect(response.status).to eq(401)
          end
        end
      end
    end
  end

  context '#new' do
    context 'when logged out' do
      it "redirects to login page" do
        get "/challenges/#{challenge.id}/submissions/new"
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    context "when logged in" do
      before do
        login_as(create(:user, role: "admin"), :scope => :user)
      end

      context "for a challenge that does not exist" do
        it "returns 404" do
          get "/challenges/#{challenge.id-1111}/submissions/new"
          expect(response.status).to eq(404)
        end
      end

      context "as an admin" do
        it "returns 200" do
          get "/challenges/#{challenge.id}/submissions/new"
          expect(response.status).to eq(200)
        end
      end

      context "as a student" do
        before do
          login_as(create(:user, role: "student"), :scope => :user)
        end

        it "returns 200" do
          get "/challenges/#{challenge.id}/submissions/new"
          expect(response.status).to eq(200)
        end
      end
    end
  end

  context "#create" do
    context 'when logged out' do
      it "redirects to login page" do
        post "/challenges/#{challenge.id}/submissions"
        expect(response).to redirect_to "/users/sign_in"
      end
    end

    context "when logged in" do
      before do
        login_as(create(:user, role: "admin"), :scope => :user)
      end

      context "for a challenge that doesn't exist" do
        it "returns 404" do
          post '/challenges/asadad/submissions'
          expect(response.status).to eq(404)
        end
      end

      context "for a challenge that exists" do
        context "without errors" do
          it "returns 302" do
            body = { submission: { sql_query: challenge.sql_correct_query } }
            expect do
              post "/challenges/#{challenge.id}/submissions", params: body
            end.to change { Submission.count }.by(1)
            expect(response.status).to eq(302)
          end
        end

        context "with errors" do
          it "returns 200" do
            body = { submission: { sql_query: "SMS" } }
            expect do
              post "/challenges/#{challenge.id}/submissions", params: body
            end.to change { Submission.count }.by(0)
            expect(response.status).to eq(200)
            expect(response.body).to include("You have an error in your SQL syntax;")
          end
        end
      end
    end
  end
end
