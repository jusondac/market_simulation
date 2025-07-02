class HomeController < ApplicationController
  def index
    @recent_recipes = Recipe.order(created_at: :desc).limit(3)
    @recent_products = Product.order(created_at: :desc).limit(3)
    @recent_packagings = Packaging.order(created_at: :desc).limit(3)
    @recent_simulations = MarketSimulation.order(created_at: :desc).limit(3)
  end
end
