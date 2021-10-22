Rails.application.routes.draw do
  devise_for :users, controllers: { 
    registrations: 'users/registrations',
    sessions: 'users/sessions' 
  }
  root to: 'books#index'
  resources :books do
    collection do
      get 'search'
    end
    resources :comments, only: [:create]
  end
  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    resources :carts, only: [:show, :create, :destroy]
    resources :borrows, only: [:index, :new, :create, :update]
  end
end
