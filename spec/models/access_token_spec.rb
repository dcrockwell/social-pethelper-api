require 'rails_helper'

describe AccessToken, type: :model do
  let(:user) { User.new }
  let(:token) { 'abc123' }
  let(:expired_token) { AccessToken.create!(user: user, token: token, expires_at: Date.today - 1) }
  let(:active_token) { AccessToken.create!(user: user, token: token, expires_at: Date.today + 1) }

  it 'scopes expired tokens' do
    expect(AccessToken.expired).to include(expired_token)
  end

  it 'scopes active tokens' do
    expect(AccessToken.active).to include(active_token)
  end

  it 'belongs to user' do
    expect(AccessToken.reflect_on_association(:user).macro).to eq(:belongs_to)
  end
end
