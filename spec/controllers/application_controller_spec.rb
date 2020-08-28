require 'rails_helper'

describe ApplicationController, :type => :controller do
    let(:valid_token) { 'abc123' }
    let(:user_name) { 'Bob T. Builder' }
    let(:user) { User.create!(name: user_name, password: 'abc123', password_confirmation: 'abc123' ) }

    before :each do
        AccessToken.create!(user: user, token: valid_token, expires_at: Date.tomorrow)
    end

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
            request.headers['Authorization'] = 'abc123'
            get :create
        end

        it 'returns OK' do
            expect(response).to have_http_status(:success)
        end

        it 'sets the current_user' do
            expect(response.body).to include_json({
                "user": user_name
            })
        end
    end

    describe 'handling Unauthorized exceptions' do
        before :each do
            get :index
        end

        it 'renders an unauthorized error' do
            expect(response.body).to include_json({
                "error": "Unauthorized"
            })
        end

        it 'returns an unauthorized status code' do
            expect(response).to have_http_status(:unauthorized)
        end
    end
end