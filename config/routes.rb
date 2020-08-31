Rails.application.routes.draw do
  resource :access_token
  resources :animals
  resources :users
end
