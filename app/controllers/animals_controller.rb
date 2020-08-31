require 'addressable/uri'

class AnimalsController < ApplicationController
  def index
    search = Search.find_or_create_by!(query_parameters: search_query)
    search.increment!(:times_searched)

    render json: { animals: search.results }, status: 200
  end

  private

  def search_params
    params.permit
  end

  def search_query
    uri = Addressable::URI.new
    uri.query_values = search_params
    uri.query
  end
end
