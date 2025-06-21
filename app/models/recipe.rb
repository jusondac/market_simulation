class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :products, dependent: :destroy
  
  validates :name, presence: true
  validates :servings, presence: true, numericality: { greater_than: 0 }
  validates :preparation_time, presence: true, numericality: { greater_than: 0 }
  
  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true, reject_if: :all_blank
  
  def total_cost
    recipe_ingredients.sum { |ri| ri.ingredient.price * ri.quantity }
  end
  
  def cost_per_serving
    return 0 if servings.zero?
    total_cost / servings
  end
  
  def ingredient_list
    recipe_ingredients.includes(:ingredient).map do |ri|
      "#{ri.quantity} #{ri.ingredient.unit} of #{ri.ingredient.name}"
    end.join(", ")
  end
end
