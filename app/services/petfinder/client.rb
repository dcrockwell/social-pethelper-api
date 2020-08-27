module Petfinder
    include Petfinder::Errors

    class Client
        DEFAULT_URL = 'https://api.petfinder.com/v2'
        TOKEN_PATH = '/oauth2/token'

        include Petfinder::Request

        attr_accessor :url, :connection, :token

        #
        # Initializes the Petfinder Client with the provided credentials and Faraday connection object
        #
        # @param [String] key Petfinder API Key (also known as a Client ID)
        # @param [String] secret Petfinder API Secret (also known as a Client Secret)
        # @param [Faraday] connection Faraday instance used to connect to Petfinder
        # @param [String] url Optional custom URL. Defaults to v2 URL.
        #
        def initialize(key:, secret:, connection:, url: DEFAULT_URL)
            validate_credentials key: key, secret: secret

            @key = key
            @secret = secret
            @url = url
            @connection = connection
        end

        #
        # Calls the Petfinder API and returns a new access token, then saves it to #token
        #
        # @raise [Petfinder::RequestError] if the request is unsuccessful
        # @return [String] Petfinder Access Token
        #
        def fetch_token
            body = post(
                path: TOKEN_PATH,
                data: {
                    grant_type: 'client_credentials',
                    client_id: @key,
                    client_secret: @secret
                }
            )

            @token = body['access_token']
        end

        private

        def validate_credentials(key:, secret:)
            raise Petfinder::KeyError, "Key is #{key.nil? ? 'nil' : 'empty string'}" if key.blank?
            raise Petfinder::SecretError, "Secret is #{secret.nil? ? 'nil' : 'empty string'}" if secret.blank?
        end
    end
end