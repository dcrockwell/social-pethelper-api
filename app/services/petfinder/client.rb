module Petfinder
  class Client
    DEFAULT_URL = 'https://api.petfinder.com/v2'.freeze
    TOKEN_PATH = '/oauth2/token'.freeze

    include Petfinder::Request
    include Petfinder::Validation
    include Petfinder::Errors

    attr_accessor :url, :connection, :token

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

    #
    # Calls the Petfinder API and returns a new access token, then saves it to #token
    #
    # @example
    #   client = Petfinder::Client.new(**configuration)
    #   client.token # => nil
    #   token = client.fetch_token
    #   client.token # => String
    #
    # @raise [Petfinder::RequestError] if the request is unsuccessful
    # @return [String] Petfinder Access Token
    #
    def fetch_token
      credentials = {
        grant_type: 'client_credentials',
        client_id: @key,
        client_secret: @secret
      }

      body = post path: TOKEN_PATH, data: credentials

      @token = body['access_token']
    end

    #
    # Fetch animal data from Petfinder
    #
    # 
    #
    # @example
    #   client = Petfinder::Client.new(**configuration)
    #   animal_data = client.animals
    #   beverly_hills_cats = client.animals(location: 90210, type: 'Cat')
    #   random_dogs = client.animals(sort: 'random', type: 'Dog')
    #
    # @raise [Petfinder::RequestError] if the request is unsuccessful
    # @return [Hash] Deserialized JSON Animal Data
    #
    def animals(**parameters)
      get(path: '/animals', data: parameters)['animals']
    end
  end
end
