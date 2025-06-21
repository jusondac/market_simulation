class MarketSimulation < ApplicationRecord
  has_many :simulation_products, dependent: :destroy
  has_many :products, through: :simulation_products
  has_many :simulation_results, dependent: :destroy
  
  validates :name, presence: true
  
  accepts_nested_attributes_for :simulation_products, allow_destroy: true, reject_if: :all_blank
  
  def total_revenue
    simulation_results.sum(:total_revenue)
  end
  
  def total_profit
    simulation_results.sum(:profit)
  end
  
  def total_units_sold
    simulation_results.sum(:quantity_sold)
  end
  
  def run_simulation!
    # Clear previous results
    simulation_results.destroy_all
    
    # Get all people for simulation
    people = Person.all
    
    simulation_products.each do |sim_product|
      product = sim_product.product
      
      people.each do |person|
        # Simple simulation logic based on taste preferences and demographics
        purchase_probability = calculate_purchase_probability(person, product)
        
        if rand < purchase_probability
          quantity = rand(1..3) # Random quantity between 1-3
          revenue = quantity * sim_product.price
          cost = quantity * product.cost
          profit = revenue - cost
          
          simulation_results.create!(
            person: person,
            product: product,
            quantity_sold: quantity,
            total_revenue: revenue,
            profit: profit
          )
        end
      end
    end
  end
  
  private
  
  def calculate_purchase_probability(person, product)
    base_probability = case person.classification
                      when 'kid' then 0.6
                      when 'teenager' then 0.7
                      when 'adult' then 0.5
                      else 0.5
                      end
    
    # Adjust based on taste preferences
    if person.taste_preference_list.any? { |taste| product.recipe.name.downcase.include?(taste.downcase) }
      base_probability += 0.2
    end
    
    # Adjust based on price (simple inverse relationship)
    price_factor = [1.0 - (product.price / 100.0), 0.1].max
    
    [base_probability * price_factor, 1.0].min
  end
end
