Rails.application.routes.draw do
  root 'home#index'

  namespace :api, format: :json do
    resources :tasks, except: [:edit, :new]
  end
end
