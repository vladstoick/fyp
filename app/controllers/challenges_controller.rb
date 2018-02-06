class ChallengesController < ApplicationController
  before_action :load_challenge, except: %i[new create index]

  def index
    authorize Challenge
    @challenges = Challenge.all
  end

  def show
    authorize @challenge
  end

  def edit
    authorize @challenge
  end

  def update
    if @challenge.update(challenge_params)
      flash[:success] = 'Sucesfully Updated'
      redirect_to challenge_path(
        id: @challenge
      )
    else
      render :edit
    end
  end

  def new
    authorize Challenge
    @challenge = Challenge.new
  end

  def create
    authorize Challenge
    @challenge = Challenge.new(challenge_params)

    if @challenge.save
      flash[:success] = 'Sucesfully created'
      redirect_to challenge_path(
        id: @challenge
      )
    else
      render :new
    end
  end

  private

  def load_challenge
    @challenge = Challenge.find_by!(id: params.require(:id))
  end

  def challenge_params
    params.require(:challenge).permit(
      :title,
      :content,
      :sql_schema,
      :sql_seed,
      :sql_correct_query
    )
  end
end
