class Ingredient < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients

  validates :name, presence: true, uniqueness: { case_sensitive: false, message: "sudah ada di database" }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true
  validates :ingredient_code, presence: true, uniqueness: true
  validates :ingredient_type, presence: true, inclusion: { in: %w[kemasan mentah] }

  scope :by_name, -> { order(:name) }
  scope :by_price, -> { order(:price) }

  before_validation :generate_ingredient_code, on: :create

  def display_price
    "#{price} per #{unit}"
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "description", "id", "ingredient_code", "name", "price", "unit", "updated_at", "ingredient_type" ]
  end

  private

  def generate_ingredient_code
    return if ingredient_code.present?

    # Find the next available code
    last_ingredient = Ingredient.order(:id).last
    next_id = last_ingredient ? last_ingredient.id + 1 : 1

    loop do
      code = "ING-#{next_id.to_s.rjust(4, '0')}"
      break self.ingredient_code = code unless Ingredient.exists?(ingredient_code: code)
      next_id += 1
    end
  end
end
