class AddLinksToMentor < ActiveRecord::Migration[5.1]
  def change
    change_table :mentors do |t|
      t.text :links, array: true, default: []
    end
  end
end
