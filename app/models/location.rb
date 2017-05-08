class Location < ApplicationRecord
  has_many :mentors_location
  has_many :mentors, through: :mentors_location

  validates :description, presence: true, uniqueness: true
end
