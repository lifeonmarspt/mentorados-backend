class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest
      t.boolean :admin, default: false
      t.string :confirmation_token, null: false
      t.timestamp :confirmed_at
      t.timestamp :last_login_at
      t.timestamps
    end
  end
end
