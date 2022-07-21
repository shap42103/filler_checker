Rails.application.routes.draw do
  root to: 'static_pages#top'
  get 'static_pages/terms'
  get 'static_pages/privacy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
