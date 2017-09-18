class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest
      t.boolean :blocked, default: false

      t.boolean :admin, default: false, null: false
      t.boolean :mentor, default: false, null: false

      t.boolean :active, default: false
      t.text :name
      t.text :bio
      t.text :picture_url
      t.text :picture
      t.integer :year_in
      t.integer :year_out
      t.text :links, default: [], array: true
      t.text :location

      t.timestamps
    end
  end
end
