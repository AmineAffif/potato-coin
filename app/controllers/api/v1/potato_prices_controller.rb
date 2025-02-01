module Api
  module V1
    class PotatoPricesController < BaseController
      def index
        return unless validate_date_parameter

        @potato_prices = PotatoPrice.where(time: params[:date].to_date.all_day).order(:time)
        
        if @potato_prices.empty?
          render_no_data_message(status: :ok)
        else
          render :index, status: :ok
        end
      end
    end
  end
end
