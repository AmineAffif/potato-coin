class Rack::Attack
  safelist("allow-localhost") do |req|
    req.ip == "127.0.0.1" || req.ip == "::1"
  end

  throttle("req/ip", limit: 100, period: 5.minutes) do |req|
    req.ip
  end

  self.throttled_responder = lambda do |request|
    [
      429,
      {'Content-Type' => 'application/json'},
      [{error: "Throttle limit reached. Please wait before retrying."}.to_json]
    ]
  end
end
