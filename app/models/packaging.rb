class Packaging < ApplicationRecord
  enum :material, {
    plastik: 0,
    kertas: 1,
    aluminium: 2,
    kaca: 3,
    karton: 4,
    logam: 5,
    bio_degradable: 6
  }

  has_many :product_packagings, dependent: :destroy
  has_many :products, through: :product_packagings

  validates :name, presence: true
  validates :size, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :material, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ "box", "capacity", "created_at", "id", "id_value", "material", "name", "price", "size", "updated_at" ]
  end

  def material_text
    I18n.t("packaging.materials.#{material}")
  end
end
