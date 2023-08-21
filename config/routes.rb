Rails.application.routes.draw do
  devise_for :instructors
  devise_for :students
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # for now we will just define a root route
  authenticated :student do
    root :to => 'students#index' , as: :authenticated_student_root
  end
  authenticated :instructor do
    root :to => 'instructors#index' , as: :authenticated_instructor_root
  end
  root "home#index"
  get "/about", to: "home#about"
  # Defines the root path route ("/")
  # root "articles#index"
end
