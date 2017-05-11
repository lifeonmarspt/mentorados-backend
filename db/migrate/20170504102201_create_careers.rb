class CreateCareers < ActiveRecord::Migration[5.1]
  def change
    create_table :careers do |t|
      t.string :description, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
