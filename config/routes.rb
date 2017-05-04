Rails.application.routes.draw do

  devise_for :users, controllers: {registrations: 'registrations'}

  resources :users, only: [:show]

  devise_scope :user do
    authenticated :user do
      root to: 'registers#index'
    end
    unauthenticated :user do
      root to: 'devise/sessions#form', as: :unauthenticated_root
    end
  end

  post 'select_register', to: "registers#select_register"

  get '/:register', to: 'register#index'
  get '/:register/:key/edit', to: 'register#edit'
  get '/:register/new', to: 'register#new'
  post '/:register', to: 'register#create'

end
