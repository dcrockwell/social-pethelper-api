require 'rails_helper'

describe 'User create', type: :request do
  let(:last_user) { User.last }
  let(:name) { 'Bob T. Builder' }
  let(:email) { 'bob@canwebuildit.com' }
  let(:password) { 'abc123' }

  describe 'with valid attributes' do
    before :each do
      post '/users', params: {
        name: name,
        email: email,
        password: password
      }
    end

    it 'creates a new user' do
      expect(last_user.email).to eql(email)
    end

    it 'responds with the user as json' do
      expect(response.body).to include_json(
        user: last_user.as_json(only: %i[id name email created_at])
      )
    end

    it 'responds with a success status' do
      expect(response).to have_http_status(:success)
    end
  end
end
