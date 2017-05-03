Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :users, only: [:show]

  devise_scope :user do
    authenticated :user do
      root to: 'registers#index'
    end
    unauthenticated :user do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :registers, except: [:destroy, :show]
  get '/registers/:register_name', to: 'registers#show', as: 'register_records'

  post 'select_register', to: "registers#select_register"
end
