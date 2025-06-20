class Product < ApplicationRecord
  belongs_to :recipe
  has_many :simulation_products, dependent: :destroy
  has_many :market_simulations, through: :simulation_products
  has_many :simulation_results, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :margin, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :calculate_cost_and_price

  def profit_per_unit
    price - cost
  end

  def profit_margin_percentage
    return 0 if price.zero?
    ((profit_per_unit / price) * 100).round(2)
  end

  def units_possible_from_recipe
    recipe.servings
  end

  private

  def calculate_cost_and_price
    self.cost = recipe.cost_per_serving
    if margin.present?
      self.price = cost * (1 + margin / 100.0)
    end
  end
end
