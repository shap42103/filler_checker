Rails.application.routes.draw do
  root to: 'static_pages#top'
  get 'static_pages/terms', as: :terms
  get 'static_pages/privacy', as: :privacy
  get 'login', to: 'user_sessions#new', as: :login
  post 'login', to: "user_sessions#create"
  delete 'logout', to: 'user_sessions#destroy', as: :logout

  resources :users
  resources :recordings, only: %i[index new create show] do
    resources :text_analyses, only: %i[new create]
    resources :results, only: %i[new create show]
  end
end
