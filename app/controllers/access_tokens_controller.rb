class AccessTokensController < ApplicationController
  skip_before_action :authenticate!
  
  def create
    email, password = authentication_params
    user = User.find_by_email(email)

    raise NotAuthorizedError unless user.authenticate(password)

    access_token = user.access_tokens.create!(expires_at: DateTime.now + 1.day)

    render json: {
      access_token: {
        token: access_token.token,
        expires_at: access_token.expires_at.utc.to_s
      }
    }, status: 200
  end

  def show
  end

  private

  def authentication_params
    params.require([:email, :password])
  end
end
