module Api
  module V1
    class BaseController < ApplicationController
      private

      def validate_date_parameter
        unless params[:date].match?(/^\d{4}-\d{2}-\d{2}$/)
          render json: { message: "Invalid date format. Please use YYYY-MM-DD" }, status: :bad_request
          return false
        end

        begin
          params[:date].to_date
          true
        rescue Date::Error
          render json: { message: "Invalid date format. Please use YYYY-MM-DD" }, status: :bad_request
          false
        end
      end

      def render_no_data_message(status: :ok)
        render json: { message: "No data available for this date" }, status: status
      end
    end
  end
end 