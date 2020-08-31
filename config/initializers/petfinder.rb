Search.petfinder(
    client: Petfinder::Client.new(
        key: ENV['PETFINDER_KEY'],
        secret: ENV['PETFINDER_SECRET'],
        connection: Faraday.new
    )
)