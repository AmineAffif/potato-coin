class AddIndexToPotatoPrices < ActiveRecord::Migration[7.1]
  def change
    add_index :potato_prices, :time
  end
end
