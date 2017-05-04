class CreateMentorsLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :mentors_locations do |t|
      t.integer :mentor_id
      t.integer :location_id
      t.timestamps
    end

    add_foreign_key :mentors_locations, :mentors
    add_foreign_key :mentors_locations, :locations
  end
end
