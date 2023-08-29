Rails.application.routes.draw do
  devise_for :instructors
  devise_for :students
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # for now we will just define a root route
  authenticated :student do
    root :to => 'students#show' , as: :authenticated_student_root
  end
  authenticated :instructor do
    root :to => 'instructors#show' , as: :authenticated_instructor_root
  end
  root "home#index"
  get "/about", to: "home#about"
  # resources :courses, only: [:index,:show]
  # resources :students do
  #   resources :courses, only: [:index]
  # end
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
  #post '/courses/search', to: 'courses#search' , as: 'search_course_post'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # for now we will just define a root route
  # authenticated :student do
  #   root :to => 'students#index' , as: :authenticated_student_root
  # end
  # authenticated :instructor do
  #   root :to => 'instructors#index' , as: :authenticated_instructor_root
  # end
  # root "home#index"
  # get "/about", to: "home#about
  # Defines the root path route ("/")
  # root "articles#index"
end
