require 'rails_helper'

describe 'Animal Search', type: :request do
  describe 'not authenticated' do
    before :each do
      get '/animals'
    end

    it 'returns unauthorized if missing Authentication header' do
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'authenticated' do
    let(:user) { User.new }
    let(:access_token) { AccessToken.create!(user: user) }
    let(:petfinder_client) { instance_double(Petfinder::Client) }
    let(:animals) { JSON.parse(File.read(Rails.root.join('spec/services/petfinder/fixtures/animals.json'))) }
    let(:last_search) { Search.last }

    subject { perform_search }

    def perform_search
      get '/animals', headers: { 'Authorization' => access_token.token }
    end

    before :each do
      Search.petfinder(client: petfinder_client)
      allow(Search.petfinder).to receive(:animals).and_return(animals)

      subject
    end

    it 'returns with successful status' do
      expect(response).to have_http_status(:success)
    end

    it 'returns unfiltered results' do
      expect(response.body).to include_json({ animals: animals })
    end

    it 'creates a new search database when unique' do
      expect(last_search.query_parameters).to be_blank
    end

    it 'has 1 time searched when unique' do
      expect(last_search.times_searched).to eql(1)
    end

    it 'increments number of times searched for non-unique searches' do
      perform_search
      expect(last_search.times_searched).to eql(2)
    end

    # it 'filters by species' do
    #   expect(response.body).to include_json(animals_by_species)
    # end

    # it 'filters by zip code'
    # it 'filters by distance'

  end
end
