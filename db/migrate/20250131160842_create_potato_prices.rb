class CreatePotatoPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :potato_prices do |t|
      t.datetime :time, null: false
      t.float :value, null: false
      t.timestamps
    end
  end
end