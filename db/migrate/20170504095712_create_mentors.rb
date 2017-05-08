class CreateMentors < ActiveRecord::Migration[5.1]
  def change
    create_table :mentors do |t|
      t.string    :name,               null: false
      t.string    :email,              null: false
      t.string    :gender,             null: false
      t.text      :bio,                null: false
      t.string    :picture
      t.string    :password_digest
      t.integer   :year_in,            null: false
      t.integer   :year_out
      t.string    :confirmation_token, null: false
      t.timestamp :confirmed_at
      t.timestamps
    end

    add_index :mentors, :email, unique: true
  end
end
