class SimulationResult < ApplicationRecord
  belongs_to :market_simulation
  belongs_to :person
  belongs_to :product
  
  validates :quantity_sold, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_revenue, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :profit, presence: true
  
  scope :profitable, -> { where('profit > 0') }
  scope :by_person_type, ->(classification) { joins(:person).where(people: { classification: classification }) }
end
