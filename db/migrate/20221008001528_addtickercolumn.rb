class Addtickercolumn < ActiveRecord::Migration[7.0]
  def change
    add_column :historical_prices, :ticker, :string
  end
end
