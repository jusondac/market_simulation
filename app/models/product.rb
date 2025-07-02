class Product < ApplicationRecord
  belongs_to :recipe, optional: true  # Dibuat optional karena sekarang bisa punya multiple resep
  has_many :product_recipes, dependent: :destroy
  has_many :recipes, through: :product_recipes
  has_many :simulation_products, dependent: :destroy
  has_many :market_simulations, through: :simulation_products
  has_many :simulation_results, dependent: :destroy
  has_many :product_packagings, dependent: :destroy
  has_many :packagings, through: :product_packagings

  accepts_nested_attributes_for :product_recipes, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :margin, presence: true, numericality: { greater_than_or_equal_to: 0 }
  # validate :must_have_at_least_one_packaging, on: :update

  before_validation :calculate_cost_and_price

  def profit_per_unit
    price - cost
  end

  def profit_margin_percentage
    return 0 if price.nil? || price.zero? || cost.nil?
    ((profit_per_unit / price) * 100).round(2)
  end

  def units_possible_from_recipe
    # Jika menggunakan recipe tunggal (legacy)
    return recipe.servings if recipe.present?

    # Jika menggunakan multiple resep
    return 1 if product_recipes.empty?

    # Ambil minimum serving dari semua resep yang digunakan
    product_recipes.map { |pr| (pr.recipe.servings / pr.quantity).floor }.min || 1
  end

  # Method baru untuk total cost dari semua resep
  def total_recipe_cost
    if recipe.present?
      # Legacy: gunakan recipe tunggal
      recipe.total_cost
    else
      # Baru: jumlahkan semua product_recipes
      product_recipes.sum(&:total_cost)
    end
  end

  def has_packaging?
    product_packagings.any?
  end

  def cheapest_packaging_price
    return 0 unless has_packaging?
    product_packagings.minimum(:price_per_package) || 0
  end

  def most_expensive_packaging_price
    return 0 unless has_packaging?
    product_packagings.maximum(:price_per_package) || 0
  end

  private

  def calculate_cost_and_price
    if recipe.present?
      # Legacy calculation
      self.cost = recipe.cost_per_serving
    else
      # New calculation: total cost dari semua resep dibagi units yang bisa diproduksi
      units = units_possible_from_recipe
      self.cost = units > 0 ? total_recipe_cost / units : 0
    end

    if margin.present?
      self.price = cost * (1 + margin / 100.0)
    end
  end
end
