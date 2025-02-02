# On simule les fluctuations du prix de la patate sur une journée.
# Les prix horaires sont définis dans le tableau suivant :
prices = [2, 4, 1, 7, 3, 8, 2, 9]

# Définition des opportunités de trade :
# Chaque trade est représenté par un hash contenant le prix d'achat, le prix de vente,
# le profit par unité (différence) et une description.
trades = [
  { buy: prices[0], sell: prices[1], profit: prices[1] - prices[0], description: "Trade 1 (2 -> 4)" },
  { buy: prices[2], sell: prices[3], profit: prices[3] - prices[2], description: "Trade 2 (1 -> 7)" },
  { buy: prices[4], sell: prices[5], profit: prices[5] - prices[4], description: "Trade 3 (3 -> 8)" },
  { buy: prices[6], sell: prices[7], profit: prices[7] - prices[6], description: "Trade 4 (2 -> 9)" }
]

# Contrainte totale : 100 tonnes maximum par jour.
total_volume = 100

# -------------------------------------------------------------------
# Scénario 1 : Répartition uniforme sur tous les trades
# On investit 25 tonnes sur chacun des 4 trades (100 / 4 = 25)
volume_scenario1 = {
  "Trade 1" => 25,
  "Trade 2" => 25,
  "Trade 3" => 25,
  "Trade 4" => 25
}
profit_scenario1 = trades.each_with_index.sum do |trade, i|
  volume = volume_scenario1["Trade #{i+1}"]
  trade[:profit] * volume
end

# -------------------------------------------------------------------
# Scénario 2 : Allocation pondérée
# On investit différemment selon la rentabilité perçue de chaque trade :
# - 10 tonnes sur Trade 1 (profit par unité = 2)
# - 50 tonnes sur Trade 2 (profit par unité = 6)
# - 20 tonnes sur Trade 3 (profit par unité = 5)
# - 20 tonnes sur Trade 4 (profit par unité = 7)
volume_scenario2 = {
  "Trade 1" => 10,
  "Trade 2" => 50,
  "Trade 3" => 20,
  "Trade 4" => 20
}
profit_scenario2 = trades.each_with_index.sum do |trade, i|
  volume = volume_scenario2["Trade #{i+1}"]
  trade[:profit] * volume
end

# -------------------------------------------------------------------
# Scénario 3 : Concentration sur les deux meilleurs trades
# Ici, on investit sur les trades les plus rentables, mais en répartissant le volume entre eux.
# Par exemple, investir 40 tonnes sur Trade 2 et 60 tonnes sur Trade 4.
volume_scenario3 = {
  "Trade 1" => 0,
  "Trade 2" => 40,
  "Trade 3" => 0,
  "Trade 4" => 60
}
profit_scenario3 = trades.each_with_index.sum do |trade, i|
  volume = volume_scenario3["Trade #{i+1}"]
  trade[:profit] * volume
end

# -------------------------------------------------------------------
# Scénario 4 : Concentration totale sur le meilleur trade
# Ici, on investit l'intégralité (100 tonnes) sur le meilleur trade.
# Dans notre cas, le meilleur trade est le Trade 4 (profit par unité = 7).
volume_scenario4 = {
  "Trade 1" => 0,
  "Trade 2" => 0,
  "Trade 3" => 0,
  "Trade 4" => 100
}
profit_scenario4 = trades.each_with_index.sum do |trade, i|
  volume = volume_scenario4["Trade #{i+1}"]
  trade[:profit] * volume
end

# -------------------------------------------------------------------
# Affichage des résultats de la simulation

puts "Simulation Complexe de Trading (Volume total = #{total_volume} tonnes)"
puts "-----------------------------------------------------"
trades.each_with_index do |trade, i|
  puts "#{trade[:description]} : Profit par unité = #{trade[:profit]}"
end
puts

# Scénario 1
puts "Scénario 1 : Répartition uniforme (25 tonnes sur chaque trade)"
volume_scenario1.each do |trade_name, volume|
  trade_index = trade_name.split.last.to_i - 1
  profit_trade = trades[trade_index][:profit] * volume
  puts "  #{trade_name} : Volume = #{volume} tonnes, Profit = #{profit_trade}"
end
puts "  Profit total = #{profit_scenario1}"
puts "-----------------------------------------------------"

# Scénario 2
puts "Scénario 2 : Allocation pondérée (10, 50, 20, 20 tonnes respectivement)"
volume_scenario2.each do |trade_name, volume|
  trade_index = trade_name.split.last.to_i - 1
  profit_trade = trades[trade_index][:profit] * volume
  puts "  #{trade_name} : Volume = #{volume} tonnes, Profit = #{profit_trade}"
end
puts "  Profit total = #{profit_scenario2}"
puts "-----------------------------------------------------"

# Scénario 3
puts "Scénario 3 : Concentration sur les deux meilleurs trades (0, 40, 0, 60 tonnes)"
volume_scenario3.each do |trade_name, volume|
  trade_index = trade_name.split.last.to_i - 1
  profit_trade = trades[trade_index][:profit] * volume
  puts "  #{trade_name} : Volume = #{volume} tonnes, Profit = #{profit_trade}"
end
puts "  Profit total = #{profit_scenario3}"
puts "-----------------------------------------------------"

# Scénario 4
puts "Scénario 4 : Concentration totale sur le meilleur trade (0, 0, 0, 100 tonnes)"
volume_scenario4.each do |trade_name, volume|
  trade_index = trade_name.split.last.to_i - 1
  profit_trade = trades[trade_index][:profit] * volume
  puts "  #{trade_name} : Volume = #{volume} tonnes, Profit = #{profit_trade}"
end
puts "  Profit total = #{profit_scenario4}"
puts "-----------------------------------------------------"

# Comparaison finale
profits = {
  "Scénario 1" => profit_scenario1,
  "Scénario 2" => profit_scenario2,
  "Scénario 3" => profit_scenario3,
  "Scénario 4" => profit_scenario4
}

best_scenario = profits.max_by { |_, profit| profit }
puts "Le meilleur scénario est #{best_scenario[0]} avec un profit total de #{best_scenario[1]}."
puts "Conclusion : Dans cet exemple, investir 100 tonnes sur le meilleur trade (Trade 4) est optimal."
