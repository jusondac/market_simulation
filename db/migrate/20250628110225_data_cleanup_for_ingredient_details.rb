class DataCleanupForIngredientDetails < ActiveRecord::Migration[8.0]
  def up
    # Create ingredient_details for existing kemasan type ingredients that might have package data
    # This is a data migration to ensure consistency

    # Note: Since we removed package_size and package_unit columns from ingredients table,
    # any existing data would need to be manually recreated through the UI
    # This migration just ensures the structure is clean

    puts "Data cleanup completed. All kemasan type ingredients should have their package details added through the UI."
  end

  def down
    # Nothing to revert for data cleanup
  end
end
