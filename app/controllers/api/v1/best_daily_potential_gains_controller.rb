module Api
  module V1
    class BestDailyPotentialGainsController < ApplicationController
      def show
        date = params[:date] || Date.yesterday.to_s
        @prices = PotatoPrice.where(time: date.to_date.all_day).order(:time)

        if @prices.empty?
          render json: { message: "No data available for this date" }, status: :not_found
          return
        end

        @date = date
        @max_profit = calculate_max_gain(@prices)
      end

      private

      # Calculates the maximum profit based on trading constraints
      def calculate_max_gain(prices)
        min_price = Float::INFINITY
        max_profit = 0.0
        @best_buy_time = nil
        @best_sell_time = nil

        prices.each do |price|
          if price.value < min_price
            min_price = price.value
            @best_buy_time = price.time
          end

          current_profit = (price.value - min_price) * 100
          if current_profit > max_profit
            max_profit = current_profit
            @best_sell_time = price.time
          end
        end

        max_profit
      end
    end
  end
end
