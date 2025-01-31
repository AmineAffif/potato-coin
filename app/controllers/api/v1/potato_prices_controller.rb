module Api
  module V1
    class PotatoPricesController < ApplicationController
      def index
        date = params[:date] || Date.today.to_s
        start_time = Time.zone.parse(date).beginning_of_day
        end_time = start_time.end_of_day

        prices = PotatoPrice.where(time: start_time..end_time).order(:time)

        render json: prices, each_serializer: PotatoPriceSerializer
      end
    end
  end
end
