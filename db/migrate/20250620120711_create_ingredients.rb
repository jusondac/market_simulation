class CreateIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.decimal :price
      t.string :unit
      t.text :description

      t.timestamps
    end
  end
end
