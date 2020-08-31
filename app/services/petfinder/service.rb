class Petfinder::Service
  class << self
    def client
      connection = Faraday::Connection.new do |builder|
        builder.adapter Faraday::Adapter::EMSynchrony
      end

      @client ||= Petfinder::Client.new(
        key: ENV['PETFINDER_KEY'],
        secret: ENV['PETFINDER_SECRET'],
        connection: connection
      )

      @client.fetch_token

      return @client
    end
  end
end
