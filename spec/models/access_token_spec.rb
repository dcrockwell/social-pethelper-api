require 'rails_helper'
require 'securerandom'

describe AccessToken, type: :model do
  let(:user) { User.new }
  let(:token) { 'abc123' }
  let(:expired_token) { AccessToken.create!(user: user, expires_at: Date.today - 1) }
  let(:active_token) { AccessToken.create!(user: user, expires_at: Date.tomorrow) }

  it 'scopes expired tokens' do
    expect(AccessToken.expired).to include(expired_token)
  end

  it 'scopes active tokens' do
    expect(AccessToken.active).to include(active_token)
  end

  it 'belongs to user' do
    expect(AccessToken.reflect_on_association(:user).macro).to eq(:belongs_to)
  end

  it 'generates a random digest for the token' do
    expect(SecureRandom).to receive(:hex).and_return token
    expect(active_token.token).to eql(token)
  end
end
