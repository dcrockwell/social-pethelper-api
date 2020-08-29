require 'securerandom'

class AccessToken < ApplicationRecord
    scope :expired, -> { where('expires_at <= ?', DateTime.now)}
    scope :active, -> { where('expires_at > ?', DateTime.now)}

    belongs_to :user
    
    before_create :generate_token

    private

    def generate_token
        self.token = SecureRandom.hex
    end
end
