class CreateMentorsCareers < ActiveRecord::Migration[5.1]
  def change
    create_table :mentors_careers do |t|
      t.integer :mentor_id
      t.integer :career_id
      t.timestamps
    end

    add_foreign_key :mentors_careers, :mentors
    add_foreign_key :mentors_careers, :careers
  end
end
