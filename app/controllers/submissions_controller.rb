class SubmissionsController < ApplicationController
  before_action :load_challenge

  def show
    @submission = Submission.find_by!(
      challenge_id: @challenge.id,
      id: params.require(:id),
    )
  end

  def new; end

  def create
    sql_query = params.require(:solution)
    result = SqlAssess::Assesor.new.assess(
      create_schema_sql_query: @challenge.sql_schema,
      instructor_sql_query: @challenge.sql_correct_query,
      seed_sql_query: @challenge.sql_seed,
      student_sql_query: sql_query
    )

    submission = Submission.create!(
      sql_query: sql_query,
      success: result.success,
      challenge_id: @challenge.id,
      metadata: {
        columns: {
          student: result.student_columns,
          instructor: result.instructor_columns,
        }
      },
    )

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
