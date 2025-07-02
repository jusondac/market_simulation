class CreateProductPackagings < ActiveRecord::Migration[8.0]
  def change
    create_table :product_packagings do |t|
      t.references :product, null: false, foreign_key: true
      t.references :packaging, null: false, foreign_key: true
      t.decimal :price_per_package

      t.timestamps
    end
  end
end
