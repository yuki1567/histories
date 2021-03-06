class ApplicationController < ActionController::Base
  before_action :basic_auth if Rails.env.production?
  before_action :store_current_location, unless: :devise_controller?
  before_action :set_search

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end

  def store_current_location
    store_location_for(:user, request.url)
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def set_search
    @search = Book.ransack(params[:q])
  end
end
