require 'rails_helper'

describe Petfinder::Client, '.animals' do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:connection) { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:client) { Petfinder::Client.new(key: 'abc123', secret: 'def456', connection: connection) }

  let(:animals_url) { client.url + '/animals' }
  let(:access_token) { 'ghi789' }

  let(:expired_token_json) { File.read(Rails.root.join('spec/services/petfinder/fixtures/expired_token.json')) }
  let(:expired_token_data) { JSON.parse(expired_token_json) }
  let(:expired_token_response) { [401, {}, expired_token_json] }

  subject { client.animals }

  before(:each) do
    client.token = access_token
    stubs.get(animals_url) { expired_token_response }
  end

  after(:each) { stubs.verify_stubbed_calls }

  it 'requests a new access token' do
    expect(client).to receive(:fetch_token)
    subject rescue 'do nothing'
  end
end
