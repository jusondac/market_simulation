class CreateSimulationResults < ActiveRecord::Migration[8.0]
  def change
    create_table :simulation_results do |t|
      t.references :market_simulation, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity_sold
      t.decimal :total_revenue
      t.decimal :profit

      t.timestamps
    end
  end
end
