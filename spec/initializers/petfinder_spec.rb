require 'rails_helper'
require Rails.root.join('config/initializers/petfinder')

describe 'Petfinder initializer' do
    after :all do
        Search.reset_petfinder
    end

    it 'provides a petfinder client to Search' do
        expect(Search.petfinder).to be_instance_of(Petfinder::Client)
    end
end