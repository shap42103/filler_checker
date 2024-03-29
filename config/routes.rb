Rails.application.routes.draw do
  root to: 'static_pages#top'
  get 'static_pages/terms', as: :terms
  get 'static_pages/privacy', as: :privacy
  get 'login', to: 'user_sessions#new', as: :login
  post 'login', to: "user_sessions#create"
  delete 'logout', to: 'user_sessions#destroy', as: :logout
  get 'results', to: "results#index"
  get 'rankings', to: "rankings#index"
  post '/google_login/callback', to: 'google_login#callback'

  resources :users
  get 'users/:id/change_password', to: "users#change_password", as: :change_password

  resources :password_resets, only: %i[new create edit update]

  resources :recordings, only: %i[new create] do
    resources :text_analyses, only: %i[new create]
    resources :results, only: %i[new create show]
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
