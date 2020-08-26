require 'rails_helper'

describe Petfinder::Client, 'initializer' do
    let(:credentials) do
        {
            key: 'abc123',
            secret: 'def456',
            url: 'https://api.petfinder.com/v2'
        }
    end

    subject { Petfinder::Client.new(**credentials) }

    describe 'with valid arguments' do
        it 'initializes without error' do
            expect { subject }.to_not raise_error
        end
    end

    describe 'with invalid arguments' do
        it 'raises exception when key is nil' do
            credentials[:key] = nil
            expect { subject }.to raise_error(Petfinder::KeyError)
        end

        it 'raises exception when key is an empty string' do
            credentials[:key] = ''
            expect { subject }.to raise_error(Petfinder::KeyError)
        end

        it 'raises exception when secret is nil' do
            credentials[:secret] = nil
            expect { subject }.to raise_error(Petfinder::SecretError)
        end

        it 'raises exception when secret is an empty string' do
            credentials[:secret] = ''
            expect { subject }.to raise_error(Petfinder::SecretError)
        end

        it 'raises exception when url is nil' do
            credentials[:url] = nil
            expect { subject }.to raise_error(Petfinder::UrlError)
        end

        it 'raises exception when url is an empty string' do
            credentials[:url] = ''
            expect { subject }.to raise_error(Petfinder::UrlError)
        end
    end
end