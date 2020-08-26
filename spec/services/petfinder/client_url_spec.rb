require 'rails_helper'

describe Petfinder::Client, 'url configuration' do
    let(:config) do
        {
            key: 'abc123',
            secret: 'def456',
            connection: Faraday.new
        }
    end

    subject { Petfinder::Client.new(**config) }

    it 'uses the provided url' do
        config[:url] = 'https://my.custom.url'
        expect(subject.url).to eql(config[:url])
    end

    it 'uses the default v2 url if none is provided' do
        expect(subject.url).to eql('https://api.petfinder.com/v2')
    end
end