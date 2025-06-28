class IngredientDetail < ApplicationRecord
  belongs_to :ingredient

  validates :package_size, presence: true, numericality: { greater_than: 0 }, if: :ingredient_is_kemasan?
  validates :package_unit, presence: true, inclusion: {
    in: ->(record) { Unit.pluck(:name) },
    message: "harus dipilih dari satuan yang tersedia"
  }, if: :ingredient_is_kemasan?

  private

  def ingredient_is_kemasan?
    ingredient&.ingredient_type == "kemasan"
  end
end
