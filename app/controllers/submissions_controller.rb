class SubmissionsController < ApplicationController
  before_action :load_challenge

  def show
    @submission = Submission.find_by!(
      challenge_id: @challenge.id,
      id: params.require(:id),
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
    sql_query = params.require(:solution)

    submission = Submission.create!(
      sql_query: sql_query,
      challenge_id: @challenge.id
    )

    authorize submission

    redirect_to challenge_submission_path(
      challenge_id: @challenge.id,
      id: submission.id
    )
  end

  private

  def load_challenge
    @challenge = Challenge.find(params.require(:challenge_id))
  end
end
