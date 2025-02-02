require 'gruff'
require 'rmagick'
include Magick

# ----------------------------
# Données de simulation
# ----------------------------
# Prix horaires simulés pour la journée (indices représentant les heures)
prices = [2, 4, 1, 7, 3, 8, 2, 9]
hours = (0...prices.size).to_a

# Définition des trades pour scénarios 1 à 3
# Trade 1 : de l'heure 0 à 1 (prix 2 -> 4)
# Trade 2 : de l'heure 2 à 3 (prix 1 -> 7)
# Trade 3 : de l'heure 4 à 5 (prix 3 -> 8)
# Trade 4 : de l'heure 6 à 7 (prix 2 -> 9)
trades = [
  { name: "Trade 1", start: 0, end: 1, profit: prices[1] - prices[0] },  # profit = 2
  { name: "Trade 2", start: 2, end: 3, profit: prices[3] - prices[2] },  # profit = 6
  { name: "Trade 3", start: 4, end: 5, profit: prices[5] - prices[4] },  # profit = 5
  { name: "Trade 4", start: 6, end: 7, profit: prices[7] - prices[6] }   # profit = 7
]

# Définition des couleurs pour chaque trade (différentes du bleu utilisé pour la courbe de base)
trade_colors = {
  "Trade 1" => "#E67E22",  # Orange
  "Trade 2" => "#27AE60",  # Vert
  "Trade 3" => "#F1C40F",  # Jaune
  "Trade 4" => "#8E44AD"   # Violet
}

# Pour le scénario 4, on utilise une couleur spécifique pour le meilleur trade
best_trade_color = "#E74C3C"  # Rouge

# ----------------------------
# Calcul des scénarios d'investissement
# ----------------------------
total_volume = 100  # en tonnes

# Scénario 1 : Répartition uniforme sur les 4 trades (25 tonnes chacun)
volume_scenario1 = { "Trade 1" => 25, "Trade 2" => 25, "Trade 3" => 25, "Trade 4" => 25 }
profit_scenario1 = trades.sum { |trade| trade[:profit] * volume_scenario1[trade[:name]] }

# Scénario 2 : Allocation pondérée (10, 50, 20, 20 tonnes)
volume_scenario2 = { "Trade 1" => 10, "Trade 2" => 50, "Trade 3" => 20, "Trade 4" => 20 }
profit_scenario2 = trades.sum { |trade| trade[:profit] * volume_scenario2[trade[:name]] }

# Scénario 3 : Concentration sur deux meilleurs trades parmi les prédéfinis (0, 40, 0, 60 tonnes)
volume_scenario3 = { "Trade 1" => 0, "Trade 2" => 40, "Trade 3" => 0, "Trade 4" => 60 }
profit_scenario3 = trades.sum { |trade| trade[:profit] * volume_scenario3[trade[:name]] }

# Scénario 4 : Concentration totale sur le "meilleur trade" de la journée.
# Définir le meilleur trade comme le segment allant du prix le plus bas au prix le plus haut ultérieur.
best_buy_index = nil
best_sell_index = nil
min_price = Float::INFINITY
best_profit = 0

prices.each_with_index do |price, i|
  if price < min_price
    min_price = price
    best_buy_index = i
  end
  if best_buy_index && i > best_buy_index
    current_profit = price - prices[best_buy_index]
    if current_profit > best_profit
      best_profit = current_profit
      best_sell_index = i
    end
  end
end

best_trade = {
  name: "Best Trade",
  start: best_buy_index,
  end: best_sell_index,
  profit: best_profit  # profit par unité
}
profit_scenario4 = total_volume * best_trade[:profit]

# Regroupons les scénarios dans une structure
scenarios = {
  "Scénario 1" => { volumes: volume_scenario1, profit: profit_scenario1, description: "Répartition uniforme sur 4 trades" },
  "Scénario 2" => { volumes: volume_scenario2, profit: profit_scenario2, description: "Allocation pondérée (10,50,20,20)" },
  "Scénario 3" => { volumes: volume_scenario3, profit: profit_scenario3, description: "Concentration sur 2 trades (0,40,0,60)" },
  "Scénario 4" => { volumes: { "Best Trade" => total_volume }, profit: profit_scenario4, description: "100 tonnes sur le meilleur trade (du prix le plus bas au plus haut)" }
}

# ----------------------------
# Méthode pour générer le graphique linéaire (line chart) d'un scénario
# ----------------------------
def generate_line_chart(scenario_name, data, prices, hours, trades, trade_colors, best_trade, best_trade_color)
  g = Gruff::Line.new('800x600')
  g.bottom_margin = 100
  g.title = "#{scenario_name} - #{data[:description]}"
  g.labels = hours.each_with_index.map { |h, i| [i, h.to_s] }.to_h
  
  # Courbe de base (prix) en bleu
  g.line_width = 1
  g.data("Prix", prices, '#0000FF')
  
  if scenario_name != "Scénario 4"
    trades.each do |trade|
      volume = data[:volumes][trade[:name]]
      if volume > 0
        trade_series = Array.new(prices.size, nil)
        (trade[:start]..trade[:end]).each { |i| trade_series[i] = prices[i] }
        g.line_width = 4
        g.data(trade[:name], trade_series, trade_colors[trade[:name]])
      end
    end
  else
    # Scénario 4 : tracer le segment du best trade
    trade_series = Array.new(prices.size, nil)
    (best_trade[:start]..best_trade[:end]).each { |i| trade_series[i] = prices[i] }
    g.line_width = 4
    g.data(best_trade[:name], trade_series, best_trade_color)
  end
  
  g.line_width = 1
  line_filename = "#{scenario_name.downcase.gsub(' ', '_')}_line.png"
  g.write(line_filename)
  puts "Graphique linéaire généré pour #{scenario_name} dans #{line_filename}"
  line_filename
end

# ----------------------------
# Méthode pour générer le graphique en barres (bar chart) d'un scénario
# ----------------------------
def generate_bar_chart(scenario_name, data, trades, trade_colors, best_trade_color)
  g = Gruff::Bar.new('800x600')
  g.title = "#{scenario_name} - Détails (Profit Total: #{data[:profit]})"
  
  # Définir l'échelle de l'axe Y de 0 à 1000
  g.minimum_value = 0
  g.maximum_value = 1000
  
  if scenario_name != "Scénario 4"
    labels = {}
    trade_values = []
    trade_colors_array = []
    
    # D'abord les trades individuels (uniquement ceux avec un volume > 0)
    current_idx = 0
    trade_number = 1
    data[:volumes].each do |trade_name, volume|
      if volume > 0
        labels[current_idx] = "Trade #{trade_number}"  # Renumérotation séquentielle
        trade = trades.find { |t| t[:name] == trade_name }
        trade_values << trade[:profit] * volume
        trade_colors_array << trade_colors[trade_name]
        current_idx += 1
        trade_number += 1
      end
    end
    
    # Ajouter le profit total à la fin
    labels[current_idx] = "Profit Total"
    trade_values << data[:profit]
    trade_colors_array << "#2980B9"  # Bleu pour le profit total
    
    g.labels = labels
    
    # Une barre par trade avec sa couleur spécifique
    trade_values.each_with_index do |value, idx|
      g.data(labels[idx], [0] * idx + [value] + [0] * (trade_values.size - idx - 1), trade_colors_array[idx])
    end
  else
    g.labels = {0 => "Best Trade"}
    g.data("Profit", [data[:profit]], best_trade_color)
  end
  
  bar_filename = "#{scenario_name.downcase.gsub(' ', '_')}_bar.png"
  g.write(bar_filename)
  puts "Graphique en barres généré pour #{scenario_name} dans #{bar_filename}"
  bar_filename
end

# ----------------------------
# Méthode pour fusionner deux images côte à côte avec RMagick
# ----------------------------
def merge_images(image1_path, image2_path, output_path)
  image1 = Image.read(image1_path).first
  image2 = Image.read(image2_path).first

  combined_width = image1.columns + image2.columns
  combined_height = [image1.rows, image2.rows].max

  # Nouvelle approche : créer une image blanche directement
  combined = Image.new(combined_width, combined_height)
  combined.background_color = 'white'
  combined.erase!  # Remplit l'image avec la couleur de fond
  
  combined.composite!(image1, 0, 0, OverCompositeOp)
  combined.composite!(image2, image1.columns, 0, OverCompositeOp)

  combined.write(output_path)
  puts "Image fusionnée enregistrée dans #{output_path}"
end

# ----------------------------
# Génération des graphiques et fusion pour chaque scénario
# ----------------------------
scenarios.each do |scenario_name, data|
  line_image = generate_line_chart(scenario_name, data, prices, hours, trades, trade_colors, best_trade, best_trade_color)
  bar_image = generate_bar_chart(scenario_name, data, trades, trade_colors, best_trade_color)
  
  output_filename = "#{scenario_name.downcase.gsub(' ', '_')}.png"
  merge_images(line_image, bar_image, output_filename)
  
  # Suppression des fichiers temporaires
  File.delete(line_image)
  File.delete(bar_image)
  puts "Fichiers temporaires supprimés : #{line_image}, #{bar_image}"
end

# ----------------------------
# Affichage des résultats textuels
# ----------------------------
puts "\n--- Résultats de la simulation ---"
scenarios.each do |scenario_name, data|
  puts "#{scenario_name} : Profit Total = #{data[:profit]}"
  if scenario_name != "Scénario 4"
    data[:volumes].each do |trade_name, volume|
      trade = trades.find { |t| t[:name] == trade_name }
      trade_profit = trade[:profit] * volume
      puts "  #{trade_name} : Volume investi = #{volume} tonnes, Profit = #{trade_profit}"
    end
  else
    puts "  Best Trade (du point #{best_trade[:start]} au point #{best_trade[:end]}) : Volume investi = #{total_volume} tonnes, Profit = #{profit_scenario4}"
  end
  puts "-------------------------------"
end

best_scenario = scenarios.max_by { |_, data| data[:profit] }
puts "\nLe meilleur scénario est #{best_scenario[0]} avec un profit total de #{best_scenario[1][:profit]}."
