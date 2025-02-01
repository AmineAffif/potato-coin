class BestDailyPotentialGainsService
  def initialize(prices)
    @prices = prices
  end

  def call
    min_price = Float::INFINITY
    max_profit = 0.0
    best_buy_time = nil
    best_sell_time = nil

    @prices.each do |price|
      if price.value < min_price
        min_price = price.value
        best_buy_time = price.time
      end

      current_profit = (price.value - min_price) * 100
      if current_profit > max_profit
        max_profit = current_profit
        best_sell_time = price.time
      end
    end

    max_profit
  end
end
