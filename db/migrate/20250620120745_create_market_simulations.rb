class CreateMarketSimulations < ActiveRecord::Migration[8.0]
  def change
    create_table :market_simulations do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
