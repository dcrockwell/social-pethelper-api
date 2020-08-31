class Petfinder::Service
  class << self
    def client
      connection = Faraday::Connection.new do |builder|
        builder.adapter Faraday::Adapter::EMSynchrony
        builder.use Faraday::HttpCache, store: Rails.cache, logger: Rails.logger
      end

      unless @client
        @client = Petfinder::Client.new(
          key: ENV['PETFINDER_KEY'],
          secret: ENV['PETFINDER_SECRET'],
          connection: connection
        )

        @client.fetch_token
      end

      return @client
    end
  end
end
