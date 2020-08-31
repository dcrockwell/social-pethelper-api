class Petfinder::Service
  class << self
    def client
      @client ||= Petfinder::Client.new(
        key: ENV['PETFINDER_KEY'],
        secret: ENV['PETFINDER_SECRET'],
        connection: Faraday.new
      )

      @client.fetch_token

      return @client
    end
  end
end
