class CreateMentorsLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :mentors_locations do |t|
      t.integer :mentor_id
      t.integer :location_id
      t.timestamps
    end

    add_foreign_key :mentors_locations, :mentors, on_delete: :cascade, on_update: :cascade
    add_foreign_key :mentors_locations, :locations, on_delete: :cascade, on_update: :cascade
  end
end
