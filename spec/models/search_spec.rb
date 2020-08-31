require 'rails_helper'

describe Search, type: :model do
  let(:query_parameters) { 'species=dog&distance=1' }
  let(:animals) { JSON.parse(File.read(Rails.root.join('spec/services/petfinder/fixtures/animals.json'))) }

  let!(:unique_search) { Search.create!(query_parameters: query_parameters) }

  it 'validates uniqueness of query parameters' do
    non_unique_search = Search.new(query_parameters: query_parameters)
    expect(non_unique_search).to have(1).errors_on(:query_parameters)
  end

  describe '.results' do
    subject { unique_search.results }

    let(:client) { instance_double(Petfinder::Client) }

    before :each do
      allow(Petfinder::Service).to receive(:client).and_return(client)
      allow(client).to receive(:animals).and_return(animals)
    end

    it 'returns results for the search from Petfinder' do
      expect(subject).to eql(animals)
    end
  end
end
