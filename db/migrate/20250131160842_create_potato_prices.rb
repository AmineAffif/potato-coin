class CreatePotatoPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :potato_prices do |t|
      t.datetime :time
      t.float :value

      t.timestamps
    end
  end
end
