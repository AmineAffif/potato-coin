# db/seeds.rb

require 'faker'
require 'securerandom'

# Supposons que vous ayez un modèle PotatoPrice avec les colonnes :time (datetime) et :value (float)
# rails g model PotatoPrice time:datetime value:float

puts 'Seeding potato prices for the last 30 days...'

# Suppression des anciens enregistrements pour éviter les doublons
PotatoPrice.delete_all

# Générer des données pour les 30 derniers jours
start_time = 30.days.ago.beginning_of_day
end_time = Time.now.end_of_hour

# Générer des fluctuations de prix réalistes
price = 20000.0 # Prix de départ, similaire au BTC
volatility = 0.05 # Volatilité moyenne (5%)

(start_time.to_i..end_time.to_i).step(1.hour).each do |timestamp|
  # Ajouter une variation aléatoire pour simuler un cours réaliste
  change_percent = (SecureRandom.random_number * 2 - 1) * volatility
  price += price * change_percent
  price = price.round(2) # Arrondir à deux décimales

  PotatoPrice.create!(
    time: Time.at(timestamp),
    value: price
  )
end

puts 'Seeding completed! 30 days of potato prices have been added.'
