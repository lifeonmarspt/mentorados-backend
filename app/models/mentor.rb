require 'securerandom'
require 'digest/sha1'

class Mentor < ApplicationRecord

  has_many :mentors_careers
  has_many :careers, through: :mentors_careers
  has_many :mentors_locations
  has_many :locations, through: :mentors_locations

  before_create :set_confirmation_token
  before_create :hash_plaintext_password
  before_update :hash_plaintext_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, email: true
  validates :gender, presence: true, inclusion: { in: ['M', 'F'] }
  validates :bio, presence: true
  validates :picture, url: true
  validates :year_in,
    presence: true,
    inclusion: { in: 1900..Date.today.year },
    format: {
      with: /(19|20)\d{2}/i,
      message: "should be a four-digit year"
    }
  validates :year_out,
    presence: false,
    allow_nil: true,
    inclusion: { in: 1900..Date.today.year },
    format: {
      with: /(19|20)\d{2}/i,
      message: "should be a four-digit year"
    }

private

  def set_confirmation_token
    self.confirmation_token = SecureRandom.hex
  end

  # @todo: sal faz mal mas aqui nao
  def hash_plaintext_password
    self.password = Digest::SHA1.hexdigest self.password
  end

end
