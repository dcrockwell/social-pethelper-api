class Search < ApplicationRecord
    class PetfinderClientError < StandardError; end
    
    validates_uniqueness_of :query_parameters

    @@petfinder = nil

    def results
        raise PetfinderClientError, 'petfinder client is not configured' unless @@petfinder

        @@petfinder.animals
    end

    def self.petfinder(client: nil)
        @@petfinder = client if client
        @@petfinder
    end
    
    def self.reset_petfinder
        @@petfinder = nil
    end
end
