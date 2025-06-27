class IngredientType < ApplicationRecord
  has_many :ingredients, primary_key: :name, foreign_key: :ingredient_type, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :by_name, -> { order(:name) }

  def self.ransackable_attributes(auth_object = nil)
    [ "name", "created_at", "updated_at" ]
  end
end
