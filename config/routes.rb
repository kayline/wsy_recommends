Rails.application.routes.draw do
  root to: 'recommendations#index'

  resources :recommendations, only: [:index, :show]
  resources :people, only: [:index, :show]
end
