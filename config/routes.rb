require 'sidekiq/web'
Rails.application.routes.draw do
  devise_for :instructors
  devise_for :students
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  Elearning::Application.routes.draw do
    mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app
  end
  authenticated :student do
    root :to => 'students#show' , as: :authenticated_student_root
  end
  authenticated :instructor do
    root :to => 'instructors#show' , as: :authenticated_instructor_root
  end
  root "home#index"
  get "/about", to: "home#about"
  resources :courses do

    collection do
      get :search
    end
    resources :chapters do
      resources :peer_reviews, only: [:index, :new, :create]
      resources :chapter_results, only: [:create, :new, :index]
    end
    resources :enrollments
  end
  resources :posts, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]
  resources :instructors
  resource :student
  get "/phone_verification", to: "phone_verifications#edit" , as: :phone_verification
  patch "/phone_verification", to: "phone_verifications#update", as: :create_phone_verification
  get "/verify_phone", to: "phone_verifications#verify", as: :verify_phone



  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server'
  get '/422', to: 'errors#unprocessable'
end
