require 'rails_helper'

describe Petfinder::Client, 'initializer' do
    before :each do
        @credentials = {
            key: 'abc123',
            secret: 'def456',
            url: 'https://api.petfinder.com/v2'
        }
    end

    describe 'with valid arguments' do
        it 'initializes without error' do
            expect { Petfinder::Client.new(**@credentials) }.to_not raise_error
        end
    end

    describe 'with invalid arguments' do
        it 'raises exception when key is nil' do
            @credentials[:key] = nil
            expect { Petfinder::Client.new(**@credentials) }.to raise_error(Petfinder::KeyError)
        end

        it 'raises exception when key is an empty string' do
            @credentials[:key] = ''
            expect { Petfinder::Client.new(**@credentials) }.to raise_error(Petfinder::KeyError)
        end

        it 'raises exception when secret is nil' do
            @credentials[:secret] = nil
            expect { Petfinder::Client.new(**@credentials) }.to raise_error(Petfinder::SecretError)
        end

        it 'raises exception when secret is an empty string' do
            @credentials[:secret] = ''
            expect { Petfinder::Client.new(**@credentials) }.to raise_error(Petfinder::SecretError)
        end

        it 'raises exception when url is nil' do
            @credentials[:url] = nil
            expect { Petfinder::Client.new(**@credentials) }.to raise_error(Petfinder::UrlError)
        end

        it 'raises exception when url is an empty string' do
            @credentials[:url] = ''
            expect { Petfinder::Client.new(**@credentials) }.to raise_error(Petfinder::UrlError)
        end
    end
end