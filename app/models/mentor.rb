class Mentor < ApplicationRecord

  has_secure_password

  has_many :mentors_careers
  has_many :careers, through: :mentors_careers
  has_many :mentors_locations
  has_many :locations, through: :mentors_locations

  before_create :set_confirmation_token

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, email: true
  validates :gender, presence: true, inclusion: { in: ['M', 'F'] }
  validates :bio, presence: true
  validates :picture, url: true
  validates :year_in,
    presence: true,
    inclusion: {
      in: 1900..Date.today.year,
      message: "should be a four-digit year"
    }
  validates :year_out,
    presence: false,
    allow_nil: true,
    inclusion: {
      in: 1900..Date.today.year,
      message: "should be a four-digit year"
    }

  def self.search(q)
    Mentor.where(["name ilike ? or bio ilike ?", "%#{q}%", "%#{q}%"])
  end

private

  def set_confirmation_token
    self.confirmation_token = SecureRandom.hex
  end

end
