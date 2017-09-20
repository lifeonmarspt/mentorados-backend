class FixUserTraits < ActiveRecord::Migration[5.1]
  def change

    table_block = -> (t) {
      t.references :user, foreign_key: true
      t.references :trait, foreign_key: true

      t.index [:user_id, :trait_id], unique: true
    }

    # previous join table did not have an ID column, recreate table
    drop_table :user_traits, &table_block
    create_table :user_traits, &table_block
  end
end
