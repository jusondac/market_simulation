class CreatePackagings < ActiveRecord::Migration[8.0]
  def change
    create_table :packagings do |t|
      t.string :name
      t.string :size
      t.string :box
      t.decimal :price
      t.integer :capacity
      t.integer :material

      t.timestamps
    end
  end
end
