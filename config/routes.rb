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

  resources :countries, except: [:destroy, :new] do
    get 'success', on: :member
  end

  resources :territories, except: [:destroy, :new] do
    get 'success', on: :member
  end

  resources :local_authority_engs, except: [:destroy, :new] do
    get 'success', on: :member
  end
end
