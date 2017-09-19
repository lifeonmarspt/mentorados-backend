class CreateUserTraits < ActiveRecord::Migration[5.1]
  def change
    create_table :user_traits, id: false do |t|
      t.references :user, foreign_key: true
      t.references :trait, foreign_key: true

      t.index [:user_id, :trait_id], unique: true
    end
  end
end
