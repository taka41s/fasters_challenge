class CreateHistoricalPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :historical_prices do |t|
      t.integer :year
      t.string :month
      t.float :open_price
      t.float :highest_price
      t.float :lowest_price
      t.integer :volume
      t.integer :close_price

      t.timestamps
    end
  end
end
