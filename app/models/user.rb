class User < ApplicationRecord

  has_one :mentor

  has_secure_password

  before_create :set_confirmation_token

  validates :email, presence: true, uniqueness: true, email: true

  def self.from_token_payload payload
    User.find(payload["id"])
  end

  def to_token_payload
    self.attributes.symbolize_keys.slice(:id, :email, :admin)
  end

private

  def set_confirmation_token
    self.confirmation_token = SecureRandom.hex
  end

end
