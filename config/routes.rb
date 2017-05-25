# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  namespace :admin do
    resources :mentors, only: [:index, :show, :create, :update, :destroy]
    resources :users, only: [:index, :show, :create, :update, :destroy]
  end

  resources :mentors, only: [:index]
  resources :users, only: [:show, :create, :update] do
    member do
      post :confirm
    end

    collection do
      post :recover
      get "reset-token/:token", to: 'users#reset_token'
      put :password
    end
  end

  post 'login', to: 'user_token#create'

  get 'meta', to: 'meta#index'
end
