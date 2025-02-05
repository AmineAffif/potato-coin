module Api
  module V1
    class BaseController < ApplicationController
      ERROR_MESSAGE = "Invalid date format. Please use YYYY-MM-DD"

      private

      def validate_date_parameter
        date_str = params[:date]
        # Vérification stricte du format "YYYY-MM-DD"
        unless date_str.is_a?(String) && date_str.match?(/\A\d{4}-\d{2}-\d{2}\z/)
          render_invalid_date
          return false
        end

        begin
          params[:date] = Date.iso8601(date_str)
          true
        rescue ArgumentError, TypeError
          render_invalid_date
          false
        end
      end

      def render_no_data_message(status: :ok)
        render json: { message: "No data available for this date" }, status: status
      end

      def render_invalid_date
        render json: { message: ERROR_MESSAGE }, status: :bad_request
      end
    end
  end
end