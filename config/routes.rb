Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/' => 'goods#index'

  get '/destroysession' => 'sessions#destroy'
  post '/createsession' => 'sessions#create'

  get '/login' => 'users#login'
  get '/new' => 'users#new'

  post '/user/create' => 'users#create'
  get '/user/show' => 'users#show'
  get '/user/edit' => 'users#edit'
  patch '/user/update' => 'users#update'
  get '/user/pass_edit' => 'users#pass_edit'
  post '/user/pass_update' => 'users#pass_update'
  patch '/user/pass_update' => 'users#pass_update'
  get '/user/good_show' => 'users#good_show'
  get '/user/my_cart' => 'users#my_cart'
  get '/user/my_goods' => 'users#my_goods'
  get '/user/show_other_user' => 'users#show_other_user'
  get '/user/sold_goods' => 'users#sold_goods'
  get '/user/purchase_show' => 'users#purchase_show'

  resources :goods
  get '/good/show' => 'goods#show'
  get '/good/back_from_bought' => 'goods#back_from_bought'
  get '/good/delete_num' => 'goods#delete_num'
  get '/landing' => 'goods#landing'
  post '/goods/new' => 'goods#create'
  delete '/goods/delete' => 'goods#delete'
  post '/goods/delete' => 'goods#delete'
  get '/for_u' => 'goods#for_u'
  get '/food' => 'goods#food'
  get '/drink' => 'goods#drink'
  get '/else' => 'goods#else'
  get '/search' => 'goods#search'

  get '/purchases/to_cart' => 'purchases#to_cart'
  post '/purchases/to_cart' => 'purchases#to_cart'
  get '/purchases/back_from_cart' => 'purchases#back_from_cart'
  get '/purchases/delete' => 'purchases#delete'

  get '/product/choose' => 'products#choose'
  post '/product/new_from_product' => 'products#new_from_product'
  post '/product/create_from_product' => 'products#create_from_product'

  resources :conversations do
    resources :messages
  end
end
