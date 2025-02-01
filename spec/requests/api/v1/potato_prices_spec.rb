require 'rails_helper'

RSpec.describe "PotatoPrices API", type: :request do
  let!(:prices) do
    [
      PotatoPrice.create!(time: "2022-08-22T09:00:00Z", value: 100.25),
      PotatoPrice.create!(time: "2022-08-22T10:00:00Z", value: 101.50)
    ]
  end

  describe "GET /api/v1/potato_prices" do
    it "returns all prices for a given day" do
      get "/api/v1/potato_prices", params: { date: "2022-08-22" }
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.length).to eq(2)
      expect(json.first["value"]).to eq(100.25)
    end

    it "returns a message if no data is found" do
      get "/api/v1/potato_prices", params: { date: "2023-01-01" }
      expect(response).to have_http_status(:ok)
      
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("No data available for this date")
    end

    it "returns an error message when date format is invalid" do
      get "/api/v1/potato_prices", params: { date: "2025-01-222" }
      expect(response).to have_http_status(:bad_request)
      
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Invalid date format. Please use YYYY-MM-DD")
    end

    it "returns an error message when date has invalid format (not YYYY-MM-DD)" do
      get "/api/v1/potato_prices", params: { date: "20258-01-22" }
      expect(response).to have_http_status(:bad_request)
      
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Invalid date format. Please use YYYY-MM-DD")
    end

  end
end
