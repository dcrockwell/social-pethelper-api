require 'rails_helper'

describe Search, type: :model do
  let(:query_parameters) { 'species=dog&distance=1' }
  let(:animals) { JSON.parse(File.read(Rails.root.join('spec/services/petfinder/fixtures/animals.json'))) }
  let(:petfinder_client) { instance_double(Petfinder::Client) }

  let!(:unique_search) { Search.create!(query_parameters: query_parameters) }

  it 'validates uniqueness of query parameters' do
    non_unique_search = Search.new(query_parameters: query_parameters)
    expect(non_unique_search).to have(1).errors_on(:query_parameters)
  end

  describe 'self.petfinder' do
    it 'is nil by default' do
      expect(Search.petfinder).to be_nil
    end
  end

  describe 'self.reset_petfinder' do
    it 'sets petfinder client to nil' do
      Search.petfinder(client: petfinder_client)
      Search.reset_petfinder
      
      expect(Search.petfinder).to be_nil
    end
  end

  describe '.results' do
    subject { unique_search.results }

    describe 'petfinder client not set' do
      it 'raises an error' do
        expect { subject }.to raise_error(Search::PetfinderClientError, 'petfinder client is not configured')
      end
    end

    describe 'petfinder client set' do
      before :each do
        Search.petfinder(client: petfinder_client)
        allow(petfinder_client).to receive(:animals).and_return(animals)
      end

      it 'returns results for the search from Petfinder' do
        expect(subject).to eql(animals)
      end
    end
  end
end
