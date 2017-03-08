Rails.application.routes.draw do
  root 'home#index'

  resources :countries
  resources :territories
end
