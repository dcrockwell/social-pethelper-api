class ApplicationController < ActionController::API
  class NotAuthorizedError < StandardError; end

  attr_reader :current_user

  before_action :authenticate!

  private

  def authenticate!
    token = request.headers['Authorization']

    raise NotAuthorizedError unless token && access_token = AccessToken.active.find_by_token(token)

    @current_user = access_token.user
  end

  rescue_from NotAuthorizedError, with: -> { render json: { error: 'Unauthorized' }, status: 401 }
  
  rescue_from ActiveRecord::RecordInvalid do |error|
    render json: { error: error.message }, status: 400
  end
end
