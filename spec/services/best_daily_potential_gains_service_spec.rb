require 'rails_helper'

RSpec.describe BestDailyPotentialGainsService do
  describe "#call" do
    context "when prices are increasing" do
      let!(:prices) do
        [
          create(:potato_price, time: Time.zone.parse("2025-01-16 08:00:00"), value: 100.0),
          create(:potato_price, time: Time.zone.parse("2025-01-16 12:00:00"), value: 105.0)
        ]
      end

      it "calculates the correct maximum profit" do
        service = described_class.new(Date.parse("2025-01-16"))
        expect(service.call).to eq(500.0) # (105.0 - 100.0) * 100 tonnes
      end
    end

    context "when prices are decreasing" do
      let!(:prices) do
        [
          create(:potato_price, time: Time.zone.parse("2025-01-16 08:00:00"), value: 105.0),
          create(:potato_price, time: Time.zone.parse("2025-01-16 12:00:00"), value: 100.0)
        ]
      end

      it "returns zero profit" do
        service = described_class.new(Date.parse("2025-01-16"))
        expect(service.call).to eq(0.0)
      end
    end

    context "when prices are stable" do
      let!(:prices) do
        [
          create(:potato_price, time: Time.zone.parse("2025-01-16 08:00:00"), value: 100.0),
          create(:potato_price, time: Time.zone.parse("2025-01-16 12:00:00"), value: 100.0)
        ]
      end

      it "returns zero profit" do
        service = described_class.new(Date.parse("2025-01-16"))
        expect(service.call).to eq(0.0)
      end
    end

    context "when no prices are available" do
      it "returns nil" do
        service = described_class.new(Date.parse("2025-01-22"))
        expect(service.call).to be_nil
      end
    end
  end
end