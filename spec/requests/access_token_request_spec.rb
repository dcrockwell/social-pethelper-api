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
        post '/access_token', params: { email: user.email, password: password }
      end

      it 'returns a new access token with default expiration' do
        access_token = user.access_tokens.last
        expected_json = {
          access_token: {
            token: access_token.token,
            expires_at: access_token.expires_at.as_json
          }
        }
        expect(response.body).to include_json(expected_json)
      end

      it 'returns a successful status' do
        expect(response).to have_http_status(:success)
      end
    end

    describe 'with invalid login information' do
      before :each do
        post '/access_token', params: { email: user.email, password: 'invalid-password' }
      end

      it 'returns unauthorized status code' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized error' do
        expected_json = {
          error: 'Unauthorized'
        }
        expect(response.body).to include_json(expected_json)
      end
    end
  end
end
