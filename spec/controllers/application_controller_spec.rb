require 'rails_helper'

describe ApplicationController, type: :controller do
  let(:user_name) { 'Bob T. Builder' }
  let(:email) { 'bob@canwebuildit.com' }
  let(:user) { User.create!(name: user_name, email: email, password: 'abc123', password_confirmation: 'abc123') }
  let(:access_token) { AccessToken.create!(user: user, expires_at: Date.tomorrow) }

  $invalid_user = User.create

  controller do
    skip_before_action :authenticate!, only: %i[not_authorized record_invalid]

    def not_authorized
      raise ApplicationController::NotAuthorizedError
    end

    def record_invalid
      raise ActiveRecord::RecordInvalid, $invalid_user
    end

    def create
      render json: { user: current_user.name }, status: 200
    end
  end

  before :each do
    routes.draw do
      get 'record_invalid' => 'anonymous#record_invalid'
      get 'not_authorized' => 'anonymous#not_authorized'
      get 'create' => 'anonymous#create'
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
      get :not_authorized
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

  describe 'handling Invalid Record' do
    before :each do
      get :record_invalid
    end

    it 'renders an unauthorized error' do
      expected_json = {
        error: 'Validation failed: ' + $invalid_user.errors.full_messages.join(', ')
      }
      expect(response.body).to include_json(expected_json)
    end

    it 'returns an unauthorized status code' do
      expect(response).to have_http_status(:bad_request)
    end
  end
end
