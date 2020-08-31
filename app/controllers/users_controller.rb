class UsersController < ApplicationController
  skip_before_action :authenticate!

  def create
    user = User.create!(user_params)

    render json: user, only: [:id, :name, :email, :created_at], root: true, status: 200
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end
