json.array! @potato_prices do |potato_price|
  json.time potato_price.time
  json.value potato_price.value
end
