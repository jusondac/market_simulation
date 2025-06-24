class AddIngredientCodeToIngredients < ActiveRecord::Migration[8.0]
  def change
    add_column :ingredients, :ingredient_code, :string
    add_index :ingredients, :ingredient_code, unique: true
  end
end
