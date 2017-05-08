class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :description
      t.float :latitude
      t.float :longitude
      t.timestamps
    end

    add_index :locations, :description, unique: true
  end
end
