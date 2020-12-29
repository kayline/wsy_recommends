Rails.application.routes.draw do
  root to: 'recommendations#index'

  resources :recommendations, only: [:index, :show]
end
