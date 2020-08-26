require 'rails_helper'

describe Petfinder::Client, '.fetch_token with invalid credentials' do
    let(:stubs) { Faraday::Adapter::Test::Stubs.new }
    let(:connection) { Faraday.new { |b| b.adapter(:test, stubs) } }
    let(:config) do
        {
            key: 'badkey',
            secret: 'badsecret',
            connection: connection
        }
    end
    let(:client) { Petfinder::Client.new(**config) }
    let(:token_url) { client.url + '/oauth2/token' }
    let(:token_response) do
        [
            401,
            {},
            %Q'{
                "type": "https://www.petfinder.com/developers/v2/docs/errors/ERR-401/",
                "status": 401,
                "title": "invalid_client",
                "detail": "Client authentication failed",
                "errors": [
                  {
                    "code": "invalid_client",
                    "title": "Unauthorized",
                    "message": "Client authentication failed",
                    "details": "Client authentication failed",
                    "href": "http://developer.petfinder.com/v2/errors.html#invalid_client"
                  }
                ],
                "hint": null
              }'
        ]
    end
    
    subject { client.fetch_token }

    before :each do
        stubs.post(token_url) { token_response }
    end
    
    after(:each) { stubs.verify_stubbed_calls }

    it 'raises an exception' do
        expect { subject }.to raise_error(Petfinder::RequestError, 'Client authentication failed')
    end
end