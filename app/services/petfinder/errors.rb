module Petfinder::Errors
    class KeyError < ArgumentError; end
    class SecretError < ArgumentError; end
    class UrlError < ArgumentError; end
end