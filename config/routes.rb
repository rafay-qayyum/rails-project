Rails.application.routes.draw do
  devise_for :instructors
  devise_for :students
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # for now we will just define a root route
  root to: "home#index"
  # Defines the root path route ("/")
  # root "articles#index"
end
