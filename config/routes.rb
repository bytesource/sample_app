SampleApp::Application.routes.draw do
  

  # Member Routes: http://guides.rubyonrails.org/routing.html#adding-more-restful-actions
  # /users/1/following  --> following_user_path(1) -- mnemonic: "following OF user no 1"
  # /users/1/followers  --> followers_user_path(1)
  resources :users do
    member do                     # 'member' method: the routes respond to urls containing the user id
      get :following, :followers  # both pages show data, so we use 'get' to arrange for the urls to respond to get requests.
    end
  end

  # related: collection routes, http://guides.rubyonrails.org/routing.html#adding-more-restful-actions
  # 'collection' is like 'member', but works without the id.
  # /photos/search      --> search_photos_path    --  mnemonic: "search of photos"
  #
  # resources :photos do
  #   collection do
  #     get :search
  #   end
  # end

  resources :users
  resources :sessions,      :only => [:new, :create, :destroy]
  resources :microposts,    :only => [:create, :destroy]
  resources :relationships, :only => [:create, :destroy]

  # Nested routes: http://guides.rubyonrails.org/routing.html#nested-resources
  # /magazines/1/ads/1/edit  --> edit_magazine_ad_path(@magazine) -- mnemonic: "edit magazine's add"
  resources :users do
    resources :microposts, :only => [:index]
  end

  
  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'

  root              :to => 'pages#home'
end

