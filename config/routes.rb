Rails.application.routes.draw do

  get 'mentors', to: 'mentors#index'

  get 'mentors/:id', to: 'mentors#show'

  post 'mentors', to: 'mentors#create'

  put 'mentors/:id', to: 'mentors#update'

  delete 'mentors/:id', to: 'mentors#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
