require 'rails_helper'

describe User, type: :model do
  let(:name) { 'Bob T. Builder' }
  let(:email) { 'bob@canwebuildityeswecan.com' }
  let(:password) { 'abc123' }
  let(:attributes) do
    {
      name: name,
      email: email,
      password: password,
      password_confirmation: password
    }
  end

  subject! { User.create!(attributes) }

  it 'has a name' do
    expect(subject.name).to eql(name)
  end

  it 'has an email' do
    expect(subject.email).to eql(email)
  end

  it 'has many access_tokens' do
    expect(User.reflect_on_association(:access_tokens).macro).to eq(:has_many)
  end

  describe 'validation' do
    it 'must have a name' do
      subject.name = nil
      expect(subject).to have(1).errors_on(:name)
    end

    it 'must have an email' do
      subject.email = nil
      expect(subject).to have(1).errors_on(:email)
    end

    it 'must have a unique email' do
      non_unique_user = User.new(attributes)
      expect(non_unique_user).to have(1).errors_on(:email)
    end
  end

  describe 'secure password' do
    let(:user) { User.find_by_name(name) }

    before :each do
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
