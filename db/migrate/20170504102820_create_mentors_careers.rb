class CreateMentorsCareers < ActiveRecord::Migration[5.1]
  def change
    create_table :mentors_careers do |t|
      t.references :user, foreign_key: true
      t.references :career, foreign_key: true
      t.timestamps
    end
  end
end
