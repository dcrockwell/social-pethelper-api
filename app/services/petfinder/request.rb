module Petfinder::Request
  private

  def post(path:, data: {}, headers: {})
    request method: :post, path: path, data: data, headers: headers
  end

  def get(path:, data: {}, headers: {})
    request method: :get, path: path, data: data, headers: headers
  end

  def request(method:, path:, data: {}, headers: {})
    headers[:Authorization] = "Bearer #{token}"

    response = connection.public_send(method, url + path, data, headers)

    body = JSON.parse(response.body)

    raise Petfinder::Client::RequestError, body['detail'] if response.status != 200

    body
  end
end
