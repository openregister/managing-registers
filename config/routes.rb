Rails.application.routes.draw do
  root 'home#index'

  resources :countries, except: [:destroy, :new] do
    get 'success', on: :member
  end

  resources :territories, except: [:destroy, :new] do
    get 'success', on: :member
  end
end
