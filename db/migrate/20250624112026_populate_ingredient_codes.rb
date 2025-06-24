class PopulateIngredientCodes < ActiveRecord::Migration[8.0]
  def up
    # Generate ingredient codes for existing ingredients
    execute <<~SQL
      UPDATE ingredients#{' '}
      SET ingredient_code = 'ING-' || LPAD(id::text, 4, '0')
      WHERE ingredient_code IS NULL;
    SQL
  end

  def down
    # Remove ingredient codes
    execute "UPDATE ingredients SET ingredient_code = NULL;"
  end
end
