class User < ApplicationRecord

  has_one :mentor

  has_secure_password

  before_create :set_confirmation_token

  validates :email, presence: true, uniqueness: true, email: true

private

  def set_confirmation_token
    self.confirmation_token = SecureRandom.hex
  end

end
