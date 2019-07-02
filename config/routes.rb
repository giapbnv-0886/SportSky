Rails.application.routes.draw do
   root "static_pages#home"

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  patch "forgot_password", to: "sessions#forgot"

  resources :users do
    resources :sportgrounds, except: %i(show destroy)
  end
  resources :sportgrounds, except: %i(new create) do
    resources :pitches, only: %i(new create edit update)
  end

  resources :pitches, except: %i(new create) do
    resource :checkingprices, only: %i(show)
    resource :checkingtimeframes, only: %i(show)
  end

  resources :account_activations, only: %i(edit)
  resources :password_resets, except: %i(index show destroy)
  resources :follows, only: %i(create destroy)
end
