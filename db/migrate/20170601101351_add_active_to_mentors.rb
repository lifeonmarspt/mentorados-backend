class AddActiveToMentors < ActiveRecord::Migration[5.1]
  def change
    add_column :mentors, :active, :bool, default: false
  end
end
