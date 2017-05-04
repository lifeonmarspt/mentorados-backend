require 'securerandom'

class Mentor < ApplicationRecord

  has_many :mentors_careers
  has_many :careers, through: :mentors_careers
  has_many :mentors_locations
  has_many :locations, through: :mentors_locations

  before_create :set_confirmation_token

private

  def set_confirmation_token
    self.confirmation_token = SecureRandom.hex
  end

end
