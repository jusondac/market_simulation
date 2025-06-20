require "csv"

class MarketSimulationsController < ApplicationController
  before_action :set_market_simulation, only: [ :show, :simulate, :export, :destroy ]

  def index
    @market_simulations = MarketSimulation.order(created_at: :desc)
  end

  def show
    @simulation_products = @market_simulation.simulation_products.includes(:product)
    @simulation_results = @market_simulation.simulation_results.includes(:product, :person)
  end

  def new
    @market_simulation = MarketSimulation.new
    @products = Product.all.order(:name)
  end

  def create
    @market_simulation = MarketSimulation.new(market_simulation_params)

    if @market_simulation.save
      # Add selected products to simulation
      if params[:product_ids].present?
        params[:product_ids].each do |product_id|
          next if product_id.blank?

          product = Product.find(product_id)
          @market_simulation.simulation_products.create!(
            product: product,
            quantity: params["quantity_#{product_id}"]&.to_i || 10,
            price: params["price_#{product_id}"]&.to_f || product.price
          )
        end
      end

      redirect_to @market_simulation, notice: "Market simulation was successfully created."
    else
      @products = Product.all.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def simulate
    # Run the market simulation
    people = Person.all

    # Clear previous results
    @market_simulation.simulation_results.destroy_all

    @market_simulation.simulation_products.each do |sim_product|
      product = sim_product.product
      people.each do |person|
        # Simple simulation logic - can be enhanced
        purchase_probability = calculate_purchase_probability(person, product)

        if rand < purchase_probability
          quantity_sold = rand(1..3) # Random quantity between 1-3
          total_revenue = quantity_sold * sim_product.price
          total_cost = quantity_sold * product.cost
          profit = total_revenue - total_cost

          @market_simulation.simulation_results.create!(
            product: product,
            person: person,
            quantity_sold: quantity_sold,
            total_revenue: total_revenue,
            profit: profit
          )
        end
      end
    end

    redirect_to @market_simulation, notice: "Simulation completed successfully!"
  end

  def destroy
    @market_simulation.destroy
    redirect_to market_simulations_path, notice: "Market simulation was successfully deleted."
  end

  def export
    @simulation_results = @market_simulation.simulation_results.includes(:product, :person)

    respond_to do |format|
      format.csv do
        csv_data = generate_csv_export
        send_data csv_data,
                  filename: "market_simulation_#{@market_simulation.id}_results_#{Date.current.strftime('%Y%m%d')}.csv",
                  type: "text/csv"
      end
    end
  end

  private

  def set_market_simulation
    @market_simulation = MarketSimulation.find(params[:id])
  end

  def market_simulation_params
    params.require(:market_simulation).permit(:name, :description)
  end

  def calculate_purchase_probability(person, product)
    base_probability = 0.3

    # Age-based preferences
    case person.classification
    when "kid"
      base_probability += 0.2 if product.name.downcase.include?("cookie") || product.name.downcase.include?("muffin")
    when "teenager"
      base_probability += 0.15 if product.name.downcase.include?("brownie") || product.name.downcase.include?("cookie")
    when "adult"
      base_probability += 0.1 if product.name.downcase.include?("cheesecake")
    end

    # Taste preferences
    person.taste_preference_list.each do |taste|
      if product.recipe.ingredients.any? { |ingredient| ingredient.name.downcase.include?(taste.downcase) }
        base_probability += 0.1
      end
    end

    # Price sensitivity
    if product.price < 5
      base_probability += 0.1
    elsif product.price > 10
      base_probability -= 0.1
    end

    [ base_probability, 0.8 ].min # Cap at 80%
  end

  def generate_csv_export
    CSV.generate(headers: true) do |csv|
      # Header row
      csv << [
        "Simulation Name",
        "Product Name",
        "Customer Name",
        "Customer Age Group",
        "Customer Taste Preferences",
        "Quantity Sold",
        "Unit Price",
        "Total Revenue",
        "Product Cost",
        "Profit",
        "Purchase Date"
      ]

      # Data rows
      @simulation_results.each do |result|
        csv << [
          @market_simulation.name,
          result.product.name,
          result.person.name,
          result.person.classification.capitalize,
          result.person.taste_preference_list.join(", "),
          result.quantity_sold,
          "$#{'%.2f' % (result.total_revenue / result.quantity_sold)}",
          "$#{'%.2f' % result.total_revenue}",
          "$#{'%.2f' % (result.total_revenue - result.profit)}",
          "$#{'%.2f' % result.profit}",
          result.created_at.strftime("%Y-%m-%d %H:%M")
        ]
      end

      # Summary rows
      csv << []
      csv << [ "SUMMARY" ]
      csv << [ "Total Units Sold", @simulation_results.sum(:quantity_sold) ]
      csv << [ "Total Revenue", "$#{'%.2f' % @simulation_results.sum(:total_revenue)}" ]
      csv << [ "Total Profit", "$#{'%.2f' % @simulation_results.sum(:profit)}" ]
      csv << [ "Unique Customers", @simulation_results.select(:person_id).distinct.count ]
      csv << [ "Conversion Rate", "#{'%.1f' % (@simulation_results.select(:person_id).distinct.count.to_f / Person.count * 100)}%" ]
    end
  end
end
