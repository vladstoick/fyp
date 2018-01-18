class SubmissionsController < ApplicationController
  before_action :load_challenge

  def show
    @submission = Submission.find_by!(
      challenge_id: @challenge.id,
      id: params.require(:id)
    )
  end

  def new; end

  def create
    sql_query = params.require(:solution)
    result = SqlAssess::Assesor.new.asses(
      @challenge.sql_schema,
      @challenge.sql_correct_query,
      @challenge.sql_seed,
      sql_query
    )

    submission = Submission.create!(
      sql_query: sql_query,
      success: result.success?,
      challenge_id: @challenge.id
    )

    redirect_to challenge_submission_path(
      challenge_id: @challenge.id,
      id: submission.id
    )
  end

  private

  def load_challenge
    @challenge = Challenge.find_by!(params.require(:challenge_id))
  end
end
