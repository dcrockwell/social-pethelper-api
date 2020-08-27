module Petfinder::Request
    private
    
    def post(path:, data:)
        request method: :post, path: path, data: data
    end

    def request(method:, path:, data:)
        response = case method
        when :post then connection.post(url + path, data)
        end

        body = JSON.parse(response.body)

        raise Petfinder::Client::RequestError, body['detail'] if response.status != 200

        return body
    end
end