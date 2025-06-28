class Ingredient < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients
  has_one :ingredient_detail, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false, message: "sudah ada di database" }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true, inclusion: {
    in: ->(record) { Unit.pluck(:name) },
    message: "harus dipilih dari satuan yang tersedia"
  }
  validates :ingredient_code, presence: true, uniqueness: true
  validates :ingredient_type, presence: true, inclusion: {
    in: ->(record) { IngredientType.pluck(:name) },
    message: "harus dipilih dari jenis bahan yang tersedia"
  }

  # Nested attributes for ingredient_detail
  accepts_nested_attributes_for :ingredient_detail, allow_destroy: true

  # Delegate package methods to ingredient_detail
  delegate :package_size, :package_unit, to: :ingredient_detail, allow_nil: true

  # Validation for package details when ingredient_type is 'kemasan'
  validate :package_details_required_for_kemasan

  scope :by_name, -> { order(:name) }
  scope :by_price, -> { order(:price) }

  before_validation :generate_ingredient_code, on: :create

  def display_price
    if ingredient_type == "kemasan" && ingredient_detail&.package_size.present?
      unit_price = price / ingredient_detail.package_size
      "#{unit_price.round(2)} per #{ingredient_detail.package_unit} (#{price} per #{unit})"
    else
      "#{price} per #{unit}"
    end
  end

  def unit_price
    if ingredient_type == "kemasan" && ingredient_detail&.package_size.present?
      price / ingredient_detail.package_size
    else
      price
    end
  end

  def effective_unit
    if ingredient_type == "kemasan" && ingredient_detail&.package_unit.present?
      ingredient_detail.package_unit
    else
      unit
    end
  end

  def total_recipe_cost
    recipe_ingredients.sum(&:calculate_cost)
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

  def package_details_required_for_kemasan
    return unless ingredient_type == "kemasan"

    if ingredient_detail.blank?
      errors.add(:base, "Detail kemasan harus diisi untuk jenis bahan 'kemasan'")
    elsif ingredient_detail.package_size.blank? || ingredient_detail.package_unit.blank?
      errors.add(:base, "Ukuran kemasan dan satuan isi harus diisi untuk jenis bahan 'kemasan'")
    end
  end
end
