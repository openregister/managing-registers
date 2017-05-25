Rails.application.routes.draw do
  devise_for :users, :team_members, :controllers => { :invitations => 'devise/invitations' }
  resources :users

  scope :team_members do
    resource :invitations, controller: 'devise/invitations'
  end

  get '/admin', to: 'users#admin', as: 'admin'
  get '/team', to: 'users#team', as: 'team'
  get '/custodians', to: 'users#custodians', as: 'custodians'

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
  resources :local_authority_types, except: [:destroy]

  post 'select_register', to: "home#select_register"
end
