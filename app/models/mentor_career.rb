class MentorCareer < ApplicationRecord
  self.table_name = 'mentors_careers'

  belongs_to :mentor
  belongs_to :career
end
