module Petfinder::Request
  private

  def post(path:, data: {}, headers: {}, maximum_retries: 1)
    request method: :post, path: path, data: data, headers: headers, maximum_retries: maximum_retries
  end

  def get(path:, data: {}, headers: {}, maximum_retries: 1)
    request method: :get, path: path, data: data, headers: headers, maximum_retries: maximum_retries
  end

  def request(method:, path:, data: {}, headers: {}, maximum_retries: 1)
    headers[:Authorization] = "Bearer #{token}"

    begin
      retries ||= 0
      response = connection.public_send(method, url + path, data, headers)
      body = JSON.parse(response.body)

      raise if response.status == 401 && body['detail'] == 'Access token invalid or expired'
    rescue
      fetch_token
      retry if (retries += 1) < maximum_retries
    end

    raise Petfinder::Client::RequestError, body['detail'] if response.status != 200

    return body
  end
end
