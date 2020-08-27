module Petfinder::Validation
    private

    def validate_credentials(key:, secret:)
        raise Petfinder::Client::KeyError, "Key is #{key.nil? ? 'nil' : 'empty string'}" if key.blank?
        raise Petfinder::Client::SecretError, "Secret is #{secret.nil? ? 'nil' : 'empty string'}" if secret.blank?
    end
end