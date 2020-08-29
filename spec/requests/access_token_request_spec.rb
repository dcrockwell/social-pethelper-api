require 'rails_helper'

describe 'AccessToken', type: :request do
  let(:password) { 'abc123' }
  let(:user) do
    User.create!(
      name: 'Bob T. Builder', 
      email: 'bob@canwebuildityeswecan.com', 
      password: password, 
      password_confirmation: password
    )
  end

  describe 'create new token' do
    describe 'with valid login information' do
      before :each do
        post '/access_token', :params => { email: user.email, password: password }
      end

      it 'returns a new access token with a 24 hour expiration'  do
        expect(response.body).to include_json({
          access_token: {
            token: user.access_tokens.last.token,
            expires_at: (DateTime.now + 1.day).utc.to_s
          }
        })
      end

      it 'returns a successful status' do
        expect(response).to have_http_status(:success)
      end
    end

    describe 'with invalid login information' do
      before :each do
        post '/access_token', :params => { email: user.email, password: 'invalid-password' }
      end

      it 'returns unauthorized status code' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized error' do
        expect(response.body).to include_json({
          error: 'Unauthorized'
        })
      end
    end
  end
end
