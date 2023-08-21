Rails.application.routes.draw do
  resources :users
  # resources :products
  # get "static_pages/home"
  # get "static_pages/help"
  #config/routes.rb
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get  "/help", to: "static_pages#help"
    get  "/about", to: "static_pages#about"
    get  "/contact", to: "static_pages#contact"
    get  "/signup", to: "users#new"
    get  "/login", to: "users#login"
    resources :users, only: %i(new show create)
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # resoures :static_pages, only: %i(home help)
end
