class ApplicationController < ActionController::Base
  # Désactiver la protection CSRF pour l'API
  protect_from_forgery with: :null_session
  
  # Forcer toutes les requêtes à être en JSON
  before_action :set_default_format
  
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

  private

  def set_default_format
    request.format = :json
  end

  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def unprocessable_entity(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end
end
