Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :articles, only: :index

  # Defines the root path route ("/")
  root "articles#index"

  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"

  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"

  get "password/edit", to: "passwords#edit"
  patch "password", to: "passwords#update"

  get "cancellation/new", to: "cancellations#new"
  post "cancellation", to: "cancellations#destroy"

  get "password_reset/new", to: "password_resets#new"
  post "password_reset", to: "password_resets#create"

  get "password_reset/edit", to: "password_resets#edit"
  patch "password_reset", to: "password_resets#update"

  delete "sign_out", to: "sessions#destroy"
end
