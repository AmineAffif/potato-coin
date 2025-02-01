module Api
  module V1
    class BestDailyPotentialGainsController < BaseController
      def show
        return unless validate_date_parameter

        @max_profit = BestDailyPotentialGainsService.new(params[:date].to_date).call
        
        if @max_profit.nil?
          render_no_data_message(status: :not_found)
        else
          render :show, status: :ok
        end
      end
    end
  end
end
