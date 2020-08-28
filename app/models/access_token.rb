class AccessToken < ApplicationRecord
    scope :expired, -> { where('expires_at <= ?', DateTime.now)}
    scope :active, -> { where('expires_at > ?', DateTime.now)}

    belongs_to :user
end
