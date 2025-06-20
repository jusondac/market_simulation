class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :name
      t.decimal :price
      t.decimal :margin
      t.decimal :cost

      t.timestamps
    end
  end
end
