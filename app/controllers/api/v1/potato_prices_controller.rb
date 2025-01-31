module Api
  module V1
    class PotatoPricesController < ApplicationController
      def index
        @potato_prices = PotatoPrice.where(time: params[:date].to_date.all_day).order(:time)
        
        respond_to do |format|
          format.json do
            if @potato_prices.empty?
              render json: { message: "No data available for this date" }, status: :not_found
            end
          end
        end
      end
    end
  end
end
