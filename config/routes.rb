Rails.application.routes.draw do
  root to: 'static_pages#top'
  get 'static_pages/terms'
  get 'static_pages/privacy'
  get 'login', to: 'user_sessions#new', as: :login
  post 'login', to: "user_sessions#create"
  delete 'logout', to: 'user_sessions#destroy', as: :logout

  resources :users
end
