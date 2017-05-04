class Location < ApplicationRecord
  has_many :mentors_locations
  has_many :mentors, through: :mentors_locations
end
