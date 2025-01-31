# Potato Coin API - Test Technique

## Description

Potato Coin API est une API REST développée en Ruby on Rails, permettant d'obtenir des informations sur les prix des pommes de terre et les meilleurs gains quotidiens potentiels.

L'API est déployée sur un serveur VPS et est accessible via HTTPS avec un reverse proxy Nginx.

## Accès à l'API

L'API est accessible via les endpoints suivants :

(limite de 100 requêtes par 5 minutes)

- **Meilleurs gains quotidiens potentiels** :

  ```bash
  GET https://potato-coin.freedynamicdns.net/api/v1/best_daily_potential_gains?date=2025-01-16
  ```

  <a href="https://potato-coin.freedynamicdns.net/api/v1/best_daily_potential_gains?date=2025-01-16" target="_blank">Tester l'endpoint best_daily_potential_gains 🤑</a>

- **Prix des pommes de terre** :

  ```bash
  GET https://potato-coin.freedynamicdns.net/api/v1/potato_prices?date=2025-01-20
  ```

  <a href="https://potato-coin.freedynamicdns.net/api/v1/potato_prices?date=2025-01-20" target="_blank">Tester l'endpoint potato_prices 📖</a>

## Technologies utilisées

- **Langage** : Ruby on Rails
- **Serveur d'application** : Puma
- **Base de données** : PostgreSQL
- **Serveur Web** : Nginx avec Let's Encrypt SSL
- **Déploiement** : VPS sous Ubuntu avec Systemd

## Installation et configuration

### Prérequis

- Ruby 3.1.2
- Bundler
- PostgreSQL
- Nginx

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

3. Configurer la base de données :

   ```bash
   rails db:setup
   ```

4. Démarrer le serveur en local :
   ```bash
   rails s
   ```

## Problèmes connus et solutions

1. **Erreur 500 : ActiveRecord::ConnectionNotEstablished**

   - Vérifier que PostgreSQL est bien démarré :
     ```bash
     sudo systemctl status postgresql
     ```
   - Vérifier que la variable `DATABASE_PASSWORD_PROD` est bien définie.

## Auteur

Amine Affif ©2025

---

🚀 **Bon trading !**
