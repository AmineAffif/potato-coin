# Potato Coin API - Test Technique

![logo potato](https://github.com/user-attachments/assets/7ba2fc3b-cb1d-4010-b4e9-9b67adc26d98)

## Description

Potato Coin API est une API REST développée en Ruby on Rails, permettant d'obtenir des informations sur les prix des pommes de terre et les meilleurs gains quotidiens potentiels.

L'API est déployée sur un serveur VPS et est accessible via HTTPS avec un reverse proxy Nginx.

## Installation et configuration

### Prérequis

- Ruby 3.1.2

### Installation

1. Cloner le dépôt :

   ```bash
   git clone https://github.com/AmineAffif/potato-coin.git
   cd potato-coin
   ```

2. Installer les dépendances :

   ```bash
   bundle install
   ```

3. Configurer la base de données (Create, Migrate, Seed -> All in one) :

   ```bash
   rails db:setup
   ```

4. Démarrer le serveur en local :
   ```bash
   rails s
   ```

## Accès à l'API

L'API est accessible via les endpoints suivants :

(limite de 100 requêtes par 5 minutes)

### Localhost

- **Meilleurs gains quotidiens potentiels** :

  ```bash
  GET http://127.0.0.1:3002/api/v1/best_daily_potential_gains?date=2025-01-16
  ```

  <a href="http://127.0.0.1:3002/api/v1/best_daily_potential_gains?date=2025-01-16" target="_blank">Aller à l'url 🤑</a>

- **Prix des pommes de terre** :

  ```bash
  GET http://127.0.0.1:3002/api/v1/potato_prices?date=2025-01-20
  ```

  <a href="http://127.0.0.1:3002/api/v1/potato_prices?date=2025-01-20" target="_blank">Aller à l'url 📖</a>

### API Deployée

- **Meilleurs gains quotidiens potentiels** :

  ```bash
  GET https://potato-coin.freedynamicdns.net/api/v1/best_daily_potential_gains?date=2025-01-16
  ```

  <a href="https://potato-coin.freedynamicdns.net/api/v1/best_daily_potential_gains?date=2025-01-16" target="_blank">Aller à l'url 🤑</a>

- **Prix des pommes de terre** :

  ```bash
  GET https://potato-coin.freedynamicdns.net/api/v1/potato_prices?date=2025-01-20
  ```

  <a href="https://potato-coin.freedynamicdns.net/api/v1/potato_prices?date=2025-01-20" target="_blank">Aller à l'url 📖</a>

## Technologies utilisées

- **Langage** : Ruby on Rails
- **Serveur d'application** : Puma
- **Base de données** : PostgreSQL

#### Optionnel (ma propre initiative)

- **Serveur Web** : Nginx avec Let's Encrypt SSL
- **Déploiement** : VPS sous Ubuntu avec Systemd

## Auteur

Amine Affif ©2025

---

🚀 **Bon trading !**

https://github.com/user-attachments/assets/0f0387e2-83c0-47b4-a2cc-be9a2d14760f

## Bonus - Analyse du MaxProfit

### Réflexion sur le calcul du MaxProfit

Dans l'implémentation de l'API, j'ai choisi de calculer le MaxProfit en identifiant le point le plus bas et le point le plus haut ultérieur de la journée, puis en simulant un investissement total sur ce trade. Cette approche pourrait sembler simpliste face à l'infinité de stratégies de trading possibles. Pour valider ce choix, j'ai développé une simulation comparative (`simulation_complexe_chart.rb`) qui analyse différents scénarios d'investissement :

### Scénarios analysés

**Scénario 1️⃣** : Répartition uniforme (25% sur chaque trade possible) 💰 **PROFIT = 500**
![scénario_1](https://github.com/user-attachments/assets/1eb0ec9f-64ff-4322-be26-ff8319bff4e4)

**Scénario 2️⃣** : Allocation pondérée (10%, 50%, 20%, 20%) 💰💰 **PROFIT = 560**
![scénario_2](https://github.com/user-attachments/assets/91f32ba5-4af9-429f-b5d4-e11b05ff53c3)

**Scénario 3️⃣** : Concentration sur les deux meilleurs trades (40%, 0%, 0%, 60%) 💰💰💰 **PROFIT = 660**
![scénario_3](https://github.com/user-attachments/assets/145953f9-890e-40b5-a4fe-09e4ede14274)

**Scénario 4️⃣** : Concentration totale sur le "meilleur trade" (100% sur min->max) 💰💰💰💰💰💰 **PROFIT = 800**
![scénario_4](https://github.com/user-attachments/assets/a5c02082-ef77-4bf7-8bcc-55a82eaf19c9)

Les résultats de cette simulation démontrent que le Scénario 4 (notre approche actuelle) génère systématiquement le profit maximum théorique.

### Limites dans un contexte réel

Bien que cette approche calcule mathématiquement le profit maximum possible, elle présente plusieurs limites dans un contexte de trading réel :

1. **Absence de vision future** : En situation réelle, impossible de savoir si un point bas est le minimum absolu de la journée
2. **Facteurs externes** : Nombreux paramètres non pris en compte (volumes disponibles, frais de transaction, slippage...)
3. **Risque concentré** : Stratégie "all-in" très risquée en pratique
4. **Timing parfait** : Suppose une exécution parfaite aux extremums, irréaliste en pratique

### Conclusion

Le calcul actuel du MaxProfit représente donc la limite théorique supérieure du gain possible, servant de benchmark idéal. Dans un contexte réel, une stratégie plus diversifiée (comme les scénarios 1-3) serait probablement plus prudente et réaliste, même si mathématiquement moins optimale.

Pour explorer les différents scénarios, vous pouvez simplement voir les graphiques affiché plus haut, ou exécuter :

```bash
ruby simulation_complexe_chart.rb
```

Cela générera des graphiques en barres (à la racine du projet) pour chaque scénario, permettant de visualiser les différences de profit.
