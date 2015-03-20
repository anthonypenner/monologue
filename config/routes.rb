Monologue::Engine.routes.draw do

  namespace :admin, path: "monologue" do
    get "/" => "posts#index", as:  "" # responds to admin_url and admin_path
    get "logout" => "sessions#destroy"
    get "login" => "sessions#new"
    resources :sessions
    resources :posts
    resources :users
    get "comments" => "comments#show", as: "comments"

    match "/post/preview"=>"posts#preview", :as=>"post_preview", :via => [:put, :post]
  end

end
