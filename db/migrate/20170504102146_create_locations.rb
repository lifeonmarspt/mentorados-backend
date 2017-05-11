class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :description, null: false, index: { unique: true }
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
  end
end
