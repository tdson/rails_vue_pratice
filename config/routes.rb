Rails.application.routes.draw do
  namespace :api, format: :json do
    resources :tasks, except: [:edit, :new]
  end
end
