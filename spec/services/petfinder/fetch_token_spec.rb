require 'rails_helper'

describe Petfinder::Client, '.fetch_token' do
    let(:stubs) { Faraday::Adapter::Test::Stubs.new }
    let(:connection) { Faraday.new { |b| b.adapter(:test, stubs) } }
    let(:config) do
        {
            key: 'abc123',
            secret: 'def456',
            connection: connection
        }
    end
    let(:client) { Petfinder::Client.new(**config) }
    let(:token_url) { client.url + '/oauth2/token' }
    let(:access_token) { 'abc123' }
    let(:token_response) do
        [
            200,
            {},
            %Q'{
                "token_type": "Bearer",
                "expires_in": 3600,
                "access_token": "#{access_token}"
            }'
        ]
    end
    
    subject { client.fetch_token }

    after(:each) { stubs.verify_stubbed_calls }

    it 'sends the client key and secret' do
        stubs.post(token_url) do |env|
            expect(env.request_body).to eql({
                grant_type: 'client_credentials',
                client_id: config[:key],
                client_secret: config[:secret]
            })
            token_response
        end
        subject
    end

    it 'saves the returned token' do
        stubs.post(token_url) { token_response }
        subject
        expect(client.token).to eql(access_token)
    end
end