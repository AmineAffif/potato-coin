module Api
  module V1
    class PotatoPricesController < BaseController
      def index
        return unless validate_date_parameter

        # Fetch prices from cache or database
        @potato_prices = Rails.cache.fetch("potato_prices/#{params[:date]}", expires_in: 12.hours) do
          PotatoPrice.for_date(params[:date].to_date).order(:time).to_a
        end

        if @potato_prices.empty?
          render_no_data_message(status: :ok)
        else
          render :index, status: :ok
        end
      end
    end
  end
end