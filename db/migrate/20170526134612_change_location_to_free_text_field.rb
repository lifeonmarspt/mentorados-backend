class ChangeLocationToFreeTextField < ActiveRecord::Migration[5.1]
  def change
    drop_table :mentors_locations do |t|
      t.bigint "mentor_id"
      t.bigint "location_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["location_id"], name: "index_mentors_locations_on_location_id"
      t.index ["mentor_id"], name: "index_mentors_locations_on_mentor_id"
    end

    drop_table :locations do |t|
      t.string "description", null: false
      t.float "latitude"
      t.float "longitude"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["description"], name: "index_locations_on_description", unique: true
    end

    change_table :mentors do |t|
      t.text :location
    end
  end
end
