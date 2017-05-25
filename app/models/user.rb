class User < ApplicationRecord
  has_one :mentor

  has_secure_password

  before_create :set_confirmation_token

  validates :email, presence: true, uniqueness: true, email: true

  validate :validate_feup_email, on: :create

  def self.from_token_request request
    email = request.params["auth"] && request.params["auth"]["email"]
    self.where({ email: email }).where.not({ confirmed_at: nil }).first
  end

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

  def validate_feup_email
    if email.split('@').last != "fe.up.pt"
      errors.add(:email, "must end with fe.up.pt")
    end
  end
end
