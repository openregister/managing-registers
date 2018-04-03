Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: 'users_controller/invitations' }

  resources :users, except: %i[index edit]
  resources :change, except: %i[new create index]
  resources :team_members, only: %i[update destroy]

  resources :teams, only: %i[index show edit update] do
    resources :team_members, only: :edit
  end

  get '/admin', to: 'users#admin', as: 'admin'

  get '/custodians', to: 'users#custodians', as: 'custodians'

  devise_scope :user do
    authenticated :user do
      root to: 'home#index'
    end
    unauthenticated :user do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  get '/:register_id', to: 'register#index', as: 'registers'
  get '/:register_id/:id/edit', to: 'register#edit', as: 'edit_register'
  get '/:register_id/new', to: 'register#new', as: 'new_register'
  post '/:register_id', to: 'register#create'
end
