class IngredientDetail < ApplicationRecord
  belongs_to :ingredient

  validates :package_size, presence: true, numericality: { greater_than: 0 }
  validates :package_unit, presence: true, inclusion: {
    in: ->(record) { Unit.pluck(:name) },
    message: "harus dipilih dari satuan yang tersedia"
  }
end
