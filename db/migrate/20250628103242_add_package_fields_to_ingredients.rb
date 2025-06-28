class AddPackageFieldsToIngredients < ActiveRecord::Migration[8.0]
  def change
    add_column :ingredients, :package_size, :decimal
    add_column :ingredients, :package_unit, :string
  end
end
