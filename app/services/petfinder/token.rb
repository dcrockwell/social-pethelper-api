module Petfinder::Token
    PATH = '/oauth2/token'
    
    attr_accessor :token

    #
    # Calls the Petfinder API and returns a new access token, then saves it to #token
    #
    # @raise [Petfinder::RequestError] if the request is unsuccessful
    # @return [String] Petfinder Access Token
    #
    def fetch_token
        body = post(
            path: PATH,
            data: {
                grant_type: 'client_credentials',
                client_id: @key,
                client_secret: @secret
            }
        )

        @token = body['access_token']
    end
end