Rails.application.routes.draw do
  devise_for :users, controllers: { 
    registrations: 'users/registrations',
    sessions: 'users/sessions' 
  }
  root to: 'books#index'
  resources :books
  resources :borrows, only: [:new, :create]
  resources :users, only: [:index, :show] do
    resources :carts, only: [:show, :create, :destroy]
  end
end
