class Search < ApplicationRecord
    class PetfinderClientError < StandardError; end
    
    validates_uniqueness_of :query_parameters

    def results
        Petfinder::Service.client.animals
    end
end
