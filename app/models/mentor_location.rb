class MentorLocation < ApplicationRecord
  self.table_name = 'mentors_locations'

  belongs_to :mentor
  belongs_to :location
end
