require 'rails_helper'

describe Petfinder::Client, '.animals' do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:connection) { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:client) { Petfinder::Client.new(key: 'abc123', secret: 'def456', connection: connection) }

  let(:animals_url) { client.url + '/animals' }
  let(:access_token) { 'ghi789' }

  let(:animals_json) { File.read(Rails.root.join('spec/services/petfinder/fixtures/animals.json')) }
  let(:animals) { JSON.parse(animals_json) }
  let(:animals_data) { animals['animals'] }
  let(:animals_response) { [200, {}, animals_json] }

  subject { client.animals }

  before(:each) do
    client.token = access_token
    $env = nil
    stubs.get(animals_url) do |env|
      $env = env
      animals_response
    end
  end

  after(:each) { stubs.verify_stubbed_calls }

  describe 'request' do
    it 'authorizes with the bearer token' do
      subject
      expect($env.request_headers).to include(
        'Authorization' => "Bearer #{access_token}"
      )
    end

    it 'returns animal data from Petfinder' do
      expect(subject).to include_json(animals_data)
    end
  end
end
