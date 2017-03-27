Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root to: 'home#index'
    end
    unauthenticated :user do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :countries, except: [:destroy]
  resources :territories, except: [:destroy]
  resources :local_authority_engs, except: [:destroy]
  resources :local_authority_types, except: [:destroy, :new]

  post 'select_register', to: "home#select_register"
end
