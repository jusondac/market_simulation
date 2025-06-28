class RemovePackageFieldsFromIngredients < ActiveRecord::Migration[8.0]
  def change
    remove_column :ingredients, :package_size, :decimal
    remove_column :ingredients, :package_unit, :string
  end
end
