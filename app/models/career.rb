class Career < ApplicationRecord
  has_many :mentors_career
  has_many :mentors, through: :mentors_career

  validates :description, presence: true, uniqueness: true
end
