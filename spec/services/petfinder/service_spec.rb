require 'rails_helper'

describe Petfinder::Service do
  let(:client) { instance_double(Petfinder::Client, fetch_token: token, token: token) }
  let(:connection) { instance_double(Faraday::Connection) }
  let(:token) { 'abc123' }

  subject { Petfinder::Service.client }

  before :each do
    allow(Faraday::Connection).to receive(:new).and_return(connection)

    Petfinder::Service.instance_variable_set("@client", nil)

    allow(Petfinder::Client).to receive(:new).with(
      key: ENV['PETFINDER_KEY'],
      secret: ENV['PETFINDER_SECRET'],
      connection: connection
    ).and_return(client)

    allow(client).to receive(:fetch_token).and_return(token)
  end

  # after(:each) {  }

  describe '.client' do
    
    describe 'first call' do
      it 'returns a Petfinder client' do
        expect(subject).to be(client)
      end

      it 'fetches an access token' do
        expect(client).to receive(:fetch_token)
        subject
      end
    end

    describe 'connection' do
      it 'is setup for asynchronous connections' do
        allow(Faraday::Connection).to receive(:new).and_yield(connection).and_return(connection)
        expect(connection).to receive(:adapter).with(Faraday::Adapter::EMSynchrony)
        expect(connection).to receive(:use).with(Faraday::HttpCache, { store: Rails.cache, logger: Rails.logger })
        subject
      end
    end

    describe 'subsequent calls' do
      it 'returns the same Petfinder client' do
        expect(subject).to be(Petfinder::Service.client)
      end

      it 'does NOT fetch a new token' do
        subject
        expect(client).to_not receive(:fetch_token)
        Petfinder::Service.client
      end
    end
  end
end
