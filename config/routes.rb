Rails.application.routes.draw do
  root "static_pages#home"
  resources :users

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  patch "forgot_password", to: "sessions#forgot"

  resources :account_activations, only: %i(edit)
  resources :password_resets, except: %i(index show destroy)
  resources :follows, only: %i(create destroy)

end
