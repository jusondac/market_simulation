class ProductPackaging < ApplicationRecord
  belongs_to :product
  belongs_to :packaging

  validates :price_per_package, presence: true, numericality: { greater_than: 0 }

  before_validation :calculate_price_per_package

  private

  def calculate_price_per_package
    if product && packaging
      product_cost = product.cost || 0
      packaging_cost = packaging.price || 0
      # Harga per package = (cost produk * kapasitas packaging) + harga packaging
      self.price_per_package = (product_cost * packaging.capacity) + packaging_cost
    end
  end
end
