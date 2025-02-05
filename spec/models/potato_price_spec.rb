require 'rails_helper'

RSpec.describe PotatoPrice, type: :model do
  it "is valid with a time and value" do
    potato_price = PotatoPrice.new(time: Time.now, value: 100.5)
    expect(potato_price).to be_valid
  end

  it "is not valid without time" do
    potato_price = PotatoPrice.new(value: 100.5)
    expect(potato_price).not_to be_valid
  end

  it "is not valid without value" do
    potato_price = PotatoPrice.new(time: Time.now)
    expect(potato_price).not_to be_valid
  end

  it "is not valid with a negative price" do
    potato_price = PotatoPrice.new(time: Time.now, value: -5)
    expect(potato_price).not_to be_valid
  end

  it "is not valid with a duplicate timestamp" do
    time = Time.now
    PotatoPrice.create!(time: time, value: 100.5)
    duplicate = PotatoPrice.new(time: time, value: 101.0)
    expect(duplicate).not_to be_valid
  end

  it "is not valid with a very small positive price" do
    potato_price = PotatoPrice.new(time: Time.now, value: 0.01)
    expect(potato_price).to be_valid
  end

  it "is not valid with an extremely large price" do
    potato_price = PotatoPrice.new(time: Time.now, value: 999999.99)
    expect(potato_price).to be_valid
  end

  it "is not valid with multiple duplicate timestamps" do
    time = Time.now
    PotatoPrice.create!(time: time, value: 100.5)
    duplicates = [
      PotatoPrice.new(time: time, value: 101.0),
      PotatoPrice.new(time: time, value: 102.0)
    ]
    duplicates.each { |duplicate| expect(duplicate).not_to be_valid }
  end
end
