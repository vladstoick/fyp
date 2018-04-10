# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  rescue_from Pundit::NotAuthorizedError, with: :handle_not_authorized

  def handle_record_not_found
    render plain: 'Not found', status: :not_found
  end

  def handle_not_authorized
    render plain: 'Not Authorized', status: :unauthorized
  end
end
