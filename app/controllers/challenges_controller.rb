# frozen_string_literal: true

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
    authorize @challenge
    if @challenge.update(challenge_params)
      flash[:success] = 'Successfully Updated'
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
    @challenge = Challenge.new(challenge_params.merge(user: current_user))

    if @challenge.save
      flash[:success] = 'Successfully created'
      redirect_to challenge_path(
        id: @challenge
      )
    else
      render :new
    end
  end

  def destroy
    authorize @challenge
    @challenge.destroy!
    flash[:success] = 'Sucesfully destroyed'
    redirect_to challenges_path
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
