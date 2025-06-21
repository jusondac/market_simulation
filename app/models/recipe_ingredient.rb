class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :recipe_id, uniqueness: { scope: :ingredient_id }
  
  def cost
    ingredient.price * quantity
  end
  
  def display_quantity
    "#{quantity} #{ingredient.unit}"
  end
end
