require 'rails_helper'
require "addressable/uri"

describe 'Animal Search', type: :request do
  describe 'authenticated' do
    let(:user) { User.new }
    let(:access_token) { AccessToken.create!(user: user) }
    let(:animals) { JSON.parse(File.read(Rails.root.join('spec/services/petfinder/fixtures/animals.json'))) }
    let(:animals_data) { animals['animals'] }
    let(:last_search) { Search.last }
    let(:client) { instance_double(Petfinder::Client) }

    let(:parameters) do
      {      
        type: 'Cat', 
        breed: 'Calico', 
        size: 'Medium', 
        gender: 'Male', 
        age: 'Baby', 
        color: 'Black', 
        coat: 'Short',
        status: 'adoptable', 
        name: 'Fluffy', 
        organization: 'CO508', 
        good_with_children: 'true',
        good_with_dogs: 'true', 
        good_with_cats: 'true', 
        location: '80218', 
        distance: '1',
        before: DateTime.yesterday.iso8601, 
        after: DateTime.tomorrow.iso8601,
        sort: 'distance', 
        page: '1', 
        limit: '100'
      }
    end

    let(:query_parameters) do
      uri = Addressable::URI.new
      uri.query_values = parameters
      uri.query
    end

    subject { perform_search }

    def perform_search(search_params: parameters)
      get '/animals', params: search_params, headers: { 'Authorization' => access_token.token }
    end

    before :each do
      allow(Petfinder::Service).to receive(:client).and_return(client)
      allow(Petfinder::Service.client).to receive(:animals).and_return(animals_data)
      subject
    end

    it 'returns with successful status' do
      expect(response).to have_http_status(:success)
    end

    it 'returns unfiltered results' do
      expect(response.body).to include_json(animals)
    end

    it 'creates a new search record in the database when unique' do
      expect(last_search.query_parameters).to eql(query_parameters)
    end

    it 'has 1 time searched when unique' do
      expect(last_search.times_searched).to eql(1)
    end

    it 'increments number of times searched for non-unique searches' do
      perform_search
      expect(last_search.times_searched).to eql(2)
    end

    it 'ignores unpermitted parameters' do
      with_unpermitted_parameters = parameters.merge(unpermitted: 'foo')
      perform_search(search_params: with_unpermitted_parameters)
      expect(last_search.query_parameters).to eql(query_parameters)
    end
  end
end
