class Ingredient < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients
  
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true
  
  scope :by_name, -> { order(:name) }
  scope :by_price, -> { order(:price) }
  
  def display_price
    "#{price} per #{unit}"
  end
end
