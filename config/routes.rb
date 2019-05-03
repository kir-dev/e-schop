Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/' => 'eschop#index'
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
  get '/good/to_cart' => 'goods#to_cart'
  get '/user/my_cart' => 'users#my_cart'
  get '/good/back_from_cart' => 'goods#back_from_cart'
  get '/user/my_goods' => 'users#my_goods'
  get '/user/show_other_user' => 'users#show_other_user'
  get '/good/show' => 'goods#show'
  get '/good/to_bought' => 'goods#to_bought'
  get '/good/back_from_bought' => 'goods#back_from_bought'
  get '/user/bought_goods' => 'users#bought_goods'
  post '/good/copy' => 'goods#copy'
  get '/good/delete_num' => 'goods#delete_num'

  resources :goods
  get '/landing' => 'goods#landing'
  post '/goods/new' => 'goods#create'
  delete 'goods/destroy' => 'goods#destroy'
  post 'goods/destroy' => 'goods#destroy'

  resources :conversations do
    resources :messages
  end
end
