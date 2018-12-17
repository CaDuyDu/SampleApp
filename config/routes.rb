Rails.application.routes.draw do
  get "users/new"

  root "static_pages#home"
  get  "/help", to: "static_pages#help"
  get  "/about", to: "static_pages#about"
  get  "/contact", to: "static_pages#contact"

  get "sessions/new"

  get  "/signup", to: "users#new"
  post "/signup", to: "users#create"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  concern :paginatable do
    get "(page/:page)", action: :index, on: :collection, as: ""
  end

  resources :users, concerns: :paginatable
end
