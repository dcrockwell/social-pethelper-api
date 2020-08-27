module Petfinder
    class Client
        DEFAULT_URL = 'https://api.petfinder.com/v2'

        include Petfinder::Request
        include Petfinder::Token
        include Petfinder::Validation
        include Petfinder::Errors

        attr_accessor :url, :connection

        #
        # Initializes the Petfinder Client with the provided credentials and Faraday connection object
        #
        # @example
        #   Petfinder::Client.new(
        #       key: '<petfinder-api-key>',
        #       secret: '<petfinder-api-secret>',
        #       connection: Faraday.new,
        #       url: 'http://optional.custom.url'
        #   )
        #
        # @param [String] key Petfinder API Key (also known as a Client ID)
        # @param [String] secret Petfinder API Secret (also known as a Client Secret)
        # @param [Faraday] connection Faraday instance used to connect to Petfinder
        # @param [String] url Optional custom URL. Defaults to v2 URL.
        #
        def initialize(key:, secret:, connection:, url: DEFAULT_URL)
            validate_credentials(key: key, secret: secret) 

            @key = key
            @secret = secret
            @url = url
            @connection = connection
        end
    end
end