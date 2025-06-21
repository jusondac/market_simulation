class SimulationProduct < ApplicationRecord
  belongs_to :market_simulation
  belongs_to :product
  
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :product_id, uniqueness: { scope: :market_simulation_id }
  
  def total_value
    quantity * price
  end
  
  def profit_per_unit
    price - product.cost
  end
  
  def total_potential_profit
    quantity * profit_per_unit
  end
end
