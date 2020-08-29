require 'rails_helper'

describe ApplicationController, type: :controller do
  let(:user_name) { 'Bob T. Builder' }
  let(:user) { User.create!(name: user_name, password: 'abc123', password_confirmation: 'abc123') }
  let(:access_token) { AccessToken.create!(user: user, expires_at: Date.tomorrow) }

  controller do
    skip_before_action :authenticate!, only: [:index]

    def index
      raise ApplicationController::NotAuthorizedError
    end

    def create
      render json: { user: current_user.name }, status: 200
    end
  end

  describe 'authenticating' do
    before :each do
      request.headers['Authorization'] = access_token.token
      get :create
    end

    it 'returns OK' do
      expect(response).to have_http_status(:success)
    end

    it 'sets the current_user' do
      expected_json = {
        user: user_name
      }
      expect(response.body).to include_json(expected_json)
    end
  end

  describe 'handling Unauthorized exceptions' do
    before :each do
      get :index
    end

    it 'renders an unauthorized error' do
      expected_json = {
        error: 'Unauthorized'
      }
      expect(response.body).to include_json(expected_json)
    end

    it 'returns an unauthorized status code' do
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
