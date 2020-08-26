require 'rails_helper'

describe Petfinder::Client, 'initializer' do
    let(:config) do
        {
            key: 'abc123',
            secret: 'def456',
            connection: Faraday.new
        }
    end   

    subject { Petfinder::Client.new(**config) }

    describe 'with valid arguments' do
        it 'initializes without error' do
            expect { subject }.to_not raise_error
        end
    end

    describe 'with invalid arguments' do
        it 'raises exception when key is nil' do
            config[:key] = nil
            expect { subject }.to raise_error(Petfinder::KeyError)
        end

        it 'raises exception when key is an empty string' do
            config[:key] = ''
            expect { subject }.to raise_error(Petfinder::KeyError)
        end

        it 'raises exception when secret is nil' do
            config[:secret] = nil
            expect { subject }.to raise_error(Petfinder::SecretError)
        end

        it 'raises exception when secret is an empty string' do
            config[:secret] = ''
            expect { subject }.to raise_error(Petfinder::SecretError)
        end
    end

    describe 'with missing keywords' do
        it 'raises exception when key is missing' do
            config.delete(:key)
            expect { subject }.to raise_error(ArgumentError, 'missing keyword: :key')
        end
        it 'raises exception when secret is missing' do
            config.delete(:secret)
            expect { subject }.to raise_error(ArgumentError, 'missing keyword: :secret')
        end
        it 'raises exception when connection is missing' do
            config.delete(:connection)
            expect { subject }.to raise_error(ArgumentError, 'missing keyword: :connection')
        end
    end
end