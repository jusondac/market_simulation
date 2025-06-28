class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :recipe_id, uniqueness: { scope: :ingredient_id }

  def cost
    calculate_cost
  end

  def calculate_cost
    if ingredient.ingredient_type == "kemasan" && ingredient.ingredient_detail&.package_size.present?
      # Untuk bahan kemasan: harga dibagi dengan isi kemasan, dikali jumlah yang dibutuhkan
      cost_per_unit = ingredient.price / ingredient.ingredient_detail.package_size
      cost_per_unit * quantity
    else
      # Untuk bahan biasa: harga dikali jumlah
      ingredient.price * quantity
    end
  end

  def display_quantity
    "#{quantity} #{ingredient.effective_unit}"
  end
end
