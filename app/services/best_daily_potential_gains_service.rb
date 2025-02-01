class BestDailyPotentialGainsService
  def initialize(date)
    @prices = PotatoPrice.where(time: date.all_day).order(:time)
  end

  def call
    return nil if @prices.empty?

    max_profit = 0
    min_price = @prices.first.value

    @prices.each do |price|
      current_profit = (price.value - min_price) * 100
      max_profit = [max_profit, current_profit].max
      min_price = [min_price, price.value].min
    end

    max_profit.round(2)
  end
end
