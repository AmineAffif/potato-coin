Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  namespace :api do
    namespace :v1 do
      resources :potato_prices, only: [:index]
      resource :best_daily_potential_gains, only: [:show]
    end
  end
end
