Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show]

  devise_scope :user do
    authenticated :user do
      root to: 'home#index'
    end
    unauthenticated :user do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :countries, except: [:destroy, :new]
  resources :territories, except: [:destroy, :new]
  resources :local_authority_engs, except: [:destroy, :new]
  resources :local_authority_types, except: [:destroy, :new]

  post 'select_register', to: "home#select_register"
end
