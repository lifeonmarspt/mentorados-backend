class CreateMentorsCareers < ActiveRecord::Migration[5.1]
  def change
    create_table :mentors_careers do |t|
      t.integer :mentor_id
      t.integer :career_id
      t.timestamps
    end

    add_foreign_key :mentors_careers, :mentors, on_delete: :cascade, on_update: :cascade
    add_foreign_key :mentors_careers, :careers, on_delete: :cascade, on_update: :cascade
  end
end
