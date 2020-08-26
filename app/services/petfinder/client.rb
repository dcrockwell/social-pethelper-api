module Petfinder
    include Petfinder::Errors

    class Client
        def initialize(key:, secret:, url:)
            validate_credentials(key, secret, url)
        end

        def validate_credentials(key, secret, url)
            raise Petfinder::KeyError if key.blank?
            raise Petfinder::SecretError if secret.blank?
            raise Petfinder::UrlError if url.blank?
        end
    end
end