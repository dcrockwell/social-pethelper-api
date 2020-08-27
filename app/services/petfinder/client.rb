module Petfinder
    include Petfinder::Errors

    DEFAULT_URL = 'https://api.petfinder.com/v2'
    TOKEN_PATH = '/oauth2/token'

    class Client
        attr_accessor :url, :connection, :token

        def initialize(key:, secret:, connection:, url: DEFAULT_URL)
            validate_credentials(key, secret)
            @key = key
            @secret = secret
            @url = url
            @connection = connection
        end

        def fetch_token
            body = post(TOKEN_PATH, {
                grant_type: 'client_credentials',
                client_id: @key,
                client_secret: @secret
            })

            @token = body['access_token']
        end

        private

        def post(path, data)
            request(:post, path, data)
        end

        def request(method, path, data)
            response = case method
            when :post then connection.post(url + path, data)
            end

            body = JSON.parse(response.body)

            raise Petfinder::RequestError, body['detail'] if response.status != 200

            return body
        end

        def validate_credentials(key, secret)
            raise Petfinder::KeyError, "Key is #{key.nil? ? 'nil' : 'empty string'}" if key.blank?
            raise Petfinder::SecretError, "Secret is #{secret.nil? ? 'nil' : 'empty string'}" if secret.blank?
        end
    end
end