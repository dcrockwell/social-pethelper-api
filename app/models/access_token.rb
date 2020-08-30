require 'securerandom'

class AccessToken < ApplicationRecord
    scope :expired, -> { where('expires_at <= ?', DateTime.now)}
    scope :active, -> { where('expires_at > ?', DateTime.now)}

    belongs_to :user
    
    before_create :generate_token
    before_create :set_expiration

    # def to_json(*)
    #     {
    #         token: token,
    #         expires_at: expires_at.to_datetime
    #     }.to_json
    # end

    private

    def set_expiration
        self.expires_at = DateTime.now + 1.day unless self.expires_at
    end

    def generate_token
        self.token = SecureRandom.hex
    end
end
