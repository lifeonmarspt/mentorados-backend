class CreateMentors < ActiveRecord::Migration[5.1]
  def change
    create_table :mentors do |t|
      t.references :user, foreign_key: true, index: { unique: true }
      t.string :name, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :gender, null: false
      t.text :bio, null: false
      t.string :picture
      t.integer :year_in, null: false
      t.integer :year_out
      t.timestamps
    end
  end
end
