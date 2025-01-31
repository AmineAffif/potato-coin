module Api
  module V1
    class BestDailyPotentialGainsController < ApplicationController
      def show
        date = params[:date] || Date.yesterday.to_s
        prices = PotatoPrice.where(time: date.to_date.all_day).order(:time)

        return render json: { message: "No data available for this date" }, status: :not_found if prices.empty?

        max_profit = calculate_max_gain(prices)

        render json: { date: date, max_profit: max_profit.round(2) }
      end

      private

      # Calculates the maximum profit based on trading constraints
      def calculate_max_gain(prices)
        min_price = Float::INFINITY
        max_profit = 0.0

        prices.each do |price|
          min_price = [min_price, price.value].min
          max_profit = [max_profit, (price.value - min_price) * 100].max
        end

        max_profit
      end
    end
  end
end
