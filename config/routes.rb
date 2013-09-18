RedditClone::Application.routes.draw do
  root to: 'links#index'
  resources :users
  resource :session, only: [:new, :create, :destroy]
  resources :links
  resources :subs
end