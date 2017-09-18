Rails.application.routes.draw do

  devise_for :users, controllers: { invitations: 'users_controller/invitations' }

  resources :users, except: [:index, :edit]
  resources :change, except: [:new, :create, :index]
  resources :team_members, only: :update

  resources :teams, only: [:index, :show, :edit, :update] do
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

  get '/:register', to: 'register#index', as: 'registers'
  get '/:register/:id/edit', to: 'register#edit', as: 'edit_register'
  get '/:register/new', to: 'register#new', as: 'new_register'
  post '/:register', to: 'register#create'

end
