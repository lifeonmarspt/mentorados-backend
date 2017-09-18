# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  namespace :admin do
    resources :mentors, only: [:index, :show, :create, :update, :destroy]
    resources :users, only: [:index, :show, :create, :update, :destroy]
  end

  resources :mentors, only: [:index]
  resources :users, only: [:show, :create, :update] do
    collection do
      get :me
    end
  end

  resources :sessions, only: [:create]

  resources :password_recovery_tokens, only: [:create, :show], constraints: { id: /.*/ }

  get 'meta', to: 'meta#index'
end
