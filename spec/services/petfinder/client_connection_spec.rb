require 'rails_helper'

describe Petfinder::Client, 'connection' do
    let(:config) do
        {
            key: 'abc123',
            secret: 'def456',
            connection: Faraday.new
        }
    end

    subject { Petfinder::Client.new(**config).connection }

    it 'uses the provided connection' do
        expect(subject).to eql(config[:connection])
    end
end