class CreateIngredientDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredient_details do |t|
      t.references :ingredient, null: false, foreign_key: true
      t.decimal :package_size
      t.string :package_unit

      t.timestamps
    end
  end
end
