# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resources :mentors, only: [:index, :show, :create, :update, :destroy]
  resources :users, only: [:index, :show, :create, :update, :destroy] do
    member do
      post :confirm
    end
  end
  get 'careers', to: 'careers#index'
  post 'login', to: 'user_token#create'
end
