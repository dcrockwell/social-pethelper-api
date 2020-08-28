require 'rails_helper'

describe User, type: :model do
  let(:name) { 'Bob T. Builder' }
  let(:email) { 'bob@canwebuildityeswecan.com' }
  let(:password) { 'abc123' }
  
  subject { User.new }

  before :each do
    subject.name = name
    subject.email = email
  end

  it 'has a name' do
    expect(subject.name).to eql(name)
  end

  it 'has an email' do
    expect(subject.email).to eql(email)
  end

  describe 'secure password' do
    let(:user) { User.find_by_name(name) }

    before :each do
      subject.password = password
      subject.password_confirmation = password
      subject.save!
    end

    it 'digests the password' do
      expect(user.password_digest).to_not eql(password)
    end

    it 'does not expose the cleartext password' do
      expect(user.password).to_not eql(password)
    end

    it 'authenticates with the correct password' do
      expect(user.authenticate(password)).to be_instance_of(User)
    end

    it 'fails authentication with an incorrect password' do
      expect(user.authenticate('wrong-password')).to be false
    end
  end
end
