class Search < ApplicationRecord
    class PetfinderClientError < StandardError; end
    
    validates_uniqueness_of :query_parameters

    def results
      Petfinder::Service.client.animals(**parameters)
    end

    private

    def parameters
      Rack::Utils.parse_nested_query(query_parameters).symbolize_keys
    end
end
