class Changecolumn < ActiveRecord::Migration[7.0]
  def change
    change_column :historical_prices, :open_price, :float, precision: 10, scale: 2
    change_column :historical_prices, :highest_price, :float, precision: 10, scale: 2
    change_column :historical_prices, :lowest_price, :float, precision: 10, scale: 2
    change_column :historical_prices, :close_price, :float, precision: 10, scale: 2
  end
end
