class CreateProductRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :product_recipes do |t|
      t.references :product, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true
      t.string :recipe_type
      t.decimal :quantity

      t.timestamps
    end
  end
end
