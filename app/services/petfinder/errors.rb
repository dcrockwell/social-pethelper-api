module Petfinder::Errors
    class KeyError < ArgumentError; end
    class SecretError < ArgumentError; end
    class ConnectionError < ArgumentError; end
    class RequestError < StandardError; end
end