class User < ApplicationRecord
    has_secure_password

    has_many :access_tokens

    validates_presence_of :name, :email
    validates_uniqueness_of :email
end
