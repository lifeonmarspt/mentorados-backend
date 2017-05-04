class Career < ApplicationRecord
  has_many :mentors_careers
  has_many :mentors, through: :mentors_careers
end
