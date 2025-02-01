require 'rails_helper'

RSpec.describe "BestDailyPotentialGain API", type: :request do
  describe "GET /api/v1/best_daily_potential_gains" do
    let!(:prices) do
      [
        PotatoPrice.create!(time: "2022-08-22T09:00:00Z", value: 100.25),
        PotatoPrice.create!(time: "2022-08-22T12:00:00Z", value: 98.50),
        PotatoPrice.create!(time: "2022-08-22T15:00:00Z", value: 103.75) # Best sell point
      ]
    end

    it "calculates the best possible gain for the given date" do
      get "/api/v1/best_daily_potential_gains", params: { date: "2022-08-22" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["max_profit"]).to eq(((103.75 - 98.50) * 100).round(2))
    end

    it "returns 0 if prices only decrease" do
      PotatoPrice.delete_all
      [
        PotatoPrice.create!(time: "2022-08-22T09:00:00Z", value: 105.00),
        PotatoPrice.create!(time: "2022-08-22T12:00:00Z", value: 102.00),
        PotatoPrice.create!(time: "2022-08-22T15:00:00Z", value: 99.00)
      ]

      get "/api/v1/best_daily_potential_gains", params: { date: "2022-08-22" }

      json = JSON.parse(response.body)
      expect(json["max_profit"]).to eq(0)
    end

    it "returns not found if no data exists for the given date" do
      get "/api/v1/best_daily_potential_gains", params: { date: "2023-01-01" }

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("No data available for this date")
    end

    it 'returns the correct JSON structure' do
      get api_v1_best_daily_potential_gains_path(date: "2022-08-22")
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      
      expect(json_response['max_profit']).to eq(((103.75 - 98.50) * 100).round(2))
    end
  end
end
