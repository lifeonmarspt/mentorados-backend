class CreateCareers < ActiveRecord::Migration[5.1]
  def change
    create_table :careers do |t|
      t.string :description
      t.timestamps
    end

    add_index :careers, :description, unique: true
  end
end
