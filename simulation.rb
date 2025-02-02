# Simulation de fluctuations du prix de la patate sur une journée.
# Les prix varient chaque heure de la manière suivante (en unités monétaires) :
# Heure 0 : 2
# Heure 1 : 4
# Heure 2 : 1
# Heure 3 : 7
# Heure 4 : 5

prices = [2, 4, 1, 7, 5]

# Identification des opportunités de trade :
# Trade 1 : Acheter à l'heure 0 (prix 2) et vendre à l'heure 1 (prix 4)
# Trade 2 : Acheter à l'heure 2 (prix 1) et vendre à l'heure 3 (prix 7)
profit_trade1_per_unit = prices[1] - prices[0]  # 4 - 2 = 2
profit_trade2_per_unit = prices[3] - prices[2]  # 7 - 1 = 6

# On considère ici une contrainte de volume maximum de 100 tonnes par jour.
# La logique à tester consiste à comparer trois scénarios d'investissement sur ces trades :

# SCÉNARIO 1 : Répartir l'investissement : 50 tonnes sur Trade 1 et 50 tonnes sur Trade 2
investment_scenario1_trade1 = 50
investment_scenario1_trade2 = 50
profit_scenario1 = (profit_trade1_per_unit * investment_scenario1_trade1) +
                   (profit_trade2_per_unit * investment_scenario1_trade2)
# Calcul :
# Trade 1 → 2 * 50 = 100
# Trade 2 → 6 * 50 = 300
# Profit total = 100 + 300 = 400

# SCÉNARIO 2 : Répartir différemment : 20 tonnes sur Trade 1 et 80 tonnes sur Trade 2
investment_scenario2_trade1 = 20
investment_scenario2_trade2 = 80
profit_scenario2 = (profit_trade1_per_unit * investment_scenario2_trade1) +
                   (profit_trade2_per_unit * investment_scenario2_trade2)
# Calcul :
# Trade 1 → 2 * 20 = 40
# Trade 2 → 6 * 80 = 480
# Profit total = 40 + 480 = 520

# SCÉNARIO 3 : Investir l'intégralité (100 tonnes) uniquement sur Trade 2
investment_scenario3_trade1 = 0
investment_scenario3_trade2 = 100
profit_scenario3 = (profit_trade1_per_unit * investment_scenario3_trade1) +
                   (profit_trade2_per_unit * investment_scenario3_trade2)
# Calcul :
# Trade 1 → 2 * 0 = 0
# Trade 2 → 6 * 100 = 600
# Profit total = 600

# Conclusion : Dans ce scénario, le Trade 2 (achat à 1, vente à 7) offre un profit par unité
# beaucoup plus élevé (6 par unité) que le Trade 1 (2 par unité).
# Ainsi, concentrer l'investissement total (100 tonnes) sur Trade 2 permet d'obtenir un profit de 600,
# ce qui est supérieur aux profits obtenus en répartissant l'investissement sur les deux trades.
# Cela confirme que, dans le cas idéal où le meilleur trade est clairement identifié,
# miser l'intégralité sur ce trade est la stratégie la plus rentable.

# Affichage des résultats
puts "Profit par unité pour Trade 1 (2 -> 4) : #{profit_trade1_per_unit}"
puts "Profit par unité pour Trade 2 (1 -> 7) : #{profit_trade2_per_unit}"
puts
puts "Scénario 1 (50 tonnes sur Trade 1 et 50 tonnes sur Trade 2) : Profit = #{profit_scenario1}"
puts "Scénario 2 (20 tonnes sur Trade 1 et 80 tonnes sur Trade 2) : Profit = #{profit_scenario2}"
puts "Scénario 3 (100 tonnes sur Trade 2 uniquement) : Profit = #{profit_scenario3}"
puts

# Comparaison des bénéfices
profits = {
  "Scénario 1" => profit_scenario1,
  "Scénario 2" => profit_scenario2,
  "Scénario 3" => profit_scenario3
}

best_scenario = profits.max_by { |_, profit| profit }
puts "Le meilleur scénario est #{best_scenario[0]} avec un profit de #{best_scenario[1]}."
puts "Conclusion : Concentrer l'investissement sur le trade le plus rentable (Trade 2) est optimal."
