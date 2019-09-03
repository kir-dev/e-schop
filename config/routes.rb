# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  get '/' => 'goods#index'
  root to: 'goods#index'

  get '/user/show' => 'users#show'
  get '/user/good_show' => 'users#good_show'
  get '/user/my_cart' => 'users#my_cart'
  get '/user/my_goods' => 'users#my_goods'
  get '/user/show_other_user' => 'users#show_other_user'
  get '/user/sold_goods' => 'users#sold_goods'
  get '/user/purchase_show' => 'users#purchase_show'

  resources :goods, only: %i[new create show index destroy]
  # get '/good/show' => 'goods#show'
  post '/goods/new' => 'goods#new'
  get '/good/edit' => 'goods#edit'
  post '/good/edit' => 'goods#edit'
  patch '/good/update' => 'goods#update'
  get '/good/back_from_bought' => 'goods#back_from_bought'
  get '/good/delete_num' => 'goods#delete_num'
  get '/for_u' => 'goods#for_u'
  get '/food' => 'goods#food'
  get '/drink' => 'goods#drink'
  get '/else' => 'goods#else'
  # get '/search' => 'goods#search'
  get :autocomplete, controller: :goods, format: 'json'
  delete '/goods/delete' => 'goods#delete'
  post '/goods/delete' => 'goods#delete'
  post '/goods/delete_all' => 'goods#delete_all'
  get '/autocomplete/', to: 'goods#autocomplete'
  get '/search/', to: 'goods#search'

  post '/goods/:id', to: 'goods#view'
  get '/tags/:id', to: 'goods#show_goods_with_tag'

  # post '/goods/new' => 'goods#create'

  get '/purchases/to_cart' => 'purchases#to_cart'
  post '/purchases/to_cart' => 'purchases#to_cart'
  get '/purchases/back_from_cart' => 'purchases#back_from_cart', as: "back_from_cart"
  get '/purchases/delete' => 'purchases#delete'

  get '/product/choose' => 'products#choose'
  post '/product/new_from_product' => 'products#new_from_product'
  post '/product/create_from_product' => 'products#create_from_product'

  get '/conversations/search/', to: 'conversations#search'
  get '/conversations/view', to: 'conversations#view'

  resources :conversations do
    resources :messages
  end
end
