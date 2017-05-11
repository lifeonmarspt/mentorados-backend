class CreateMentorsLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :mentors_locations do |t|
      t.references :mentor, foreign_key: true
      t.references :location, foreign_key: true
      t.timestamps
    end
  end
end
