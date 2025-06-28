class AddQuantityToIngredients < ActiveRecord::Migration[8.0]
  def change
    add_column :ingredients, :quantity, :decimal
  end
end
