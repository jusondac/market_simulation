class ChangeRecipeIdToOptionalInProducts < ActiveRecord::Migration[8.0]
  def change
    change_column_null :products, :recipe_id, true
  end
end
