Rails.application.routes.draw do
  root 'home#index'
  get '/about', to: 'home#index'
  get '/contact', to: 'home#index'

  namespace :api, format: :json do
    resources :tasks, except: [:edit, :new]
  end
end
