require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  root to: 'import_purchases#index'

  resources :import_purchases
  get 'import_purchases/:id', to: 'import_purchases#show'
  get :purchases, to: 'purchases#index'
  get :customers, to: 'customers#index'
  get :itens, to: 'itens#index'
  get :merchants, to: 'merchants#index'
end
