# frozen_string_literal: true

require 'csv'

class SubmissionsController < ApplicationController
  before_action :load_challenge

  def index
    respond_to do |format|
      format.html do
        @submissions = @challenge.submissions
        authorize @submissions
      end

      format.csv do
        submissions = @challenge.best_submissions.includes(:user)

        authorize submissions

        final_csv = CSV.generate do |csv|
          csv << %w[email grade]

          submissions.each do |submission|
            csv << [submission.user.email, submission.max_grade]
          end
        end

        send_data(
          final_csv,
          filename: "grades_for_#{@challenge.title}.csv",
          type: :csv
        )
      end
    end
  end

  def show
    @submission = Submission.find_by!(
      challenge_id: @challenge.id,
      id: params.require(:id)
    )
    authorize @submission
  end

  def report
    @submission = Submission.find_by!(
      challenge_id: @challenge.id,
      id: params.require(:id)
    )
    authorize @submission
  end

  def new
    @submission = Submission.new(
      challenge_id: @challenge.id
    )

    authorize @submission
  end

  def create
    @submission = Submission.new(
      sql_query: params.require(:submission).require(:sql_query),
      challenge_id: @challenge.id,
      user_id: current_user.id
    )

    authorize @submission

    if @submission.save
      flash[:success] = 'Successfully submitted!'
      redirect_to challenge_submission_path(
        challenge_id: @challenge.id,
        id: @submission.id
      )
    else
      render :new
    end
  end

  private

  def load_challenge
    @challenge = Challenge.find(params.require(:challenge_id))
  end
end
