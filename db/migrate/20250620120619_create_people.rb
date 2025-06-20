class CreatePeople < ActiveRecord::Migration[8.0]
  def change
    create_table :people do |t|
      t.string :name
      t.integer :age
      t.string :classification
      t.text :taste_preferences

      t.timestamps
    end
  end
end
