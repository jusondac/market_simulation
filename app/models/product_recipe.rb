class ProductRecipe < ApplicationRecord
  belongs_to :product
  belongs_to :recipe

  validates :recipe_type, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  # Menghitung total biaya untuk resep ini
  def total_cost
    recipe.total_cost * quantity
  end
end
