module Petfinder
    include Petfinder::Errors

    class Client
        attr_accessor :url, :connection, :token

        def initialize(key:, secret:, connection:, url: 'https://api.petfinder.com/v2')
            validate_credentials(key, secret)
            @key = key
            @secret = secret
            @url = url
            @connection = connection
        end

        def fetch_token
            body = post('/oauth2/token', {
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
            raise Petfinder::KeyError if key.blank?
            raise Petfinder::SecretError if secret.blank?
        end
    end
end