module Api
  module V1
    class BestDailyPotentialGainsController < ApplicationController
      def show
        date = params[:date] || Date.yesterday.to_s
        prices = PotatoPrice.where(time: date.to_date.all_day).order(:time)

        if prices.empty?
          render json: { message: "No data available for this date" }, status: :not_found and return
        end

        @max_profit = BestDailyPotentialGainsService.new(prices).call
      end
    end
  end
end
