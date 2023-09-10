Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # Landing Page
  root 'welcome#index'

  # Markets
  resources :markets, only: %i[index show]

  # Vendors
  resources :vendors, only: %i[show]
end
