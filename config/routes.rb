SenchaApi::Application.routes.draw do
  resources :todos


  devise_for :users

  get "home/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'
  match "/api", :to => "home#show_api", :as => :show_api


   # api para la mobile
   #this is for api for the mobile app
  namespace :api do
    resources :tokens,:only => [:create, :destroy]
  end
  match '/api/tokens/create', :to => 'api/tokens#create', :as => :login
  
  match '/api/api/list_todos', :to => 'api/api#list_todos', :as => :list_todos_json
  match '/api/api/add_todo', :to => 'api/api#add_todo', :as => :add_todo_json
  match '/api/api/delete_todo', :to => 'api/api#delete_todo', :as => :delete_todo_json

  # match '/api/api/comments', :to => 'api/api#comments', :as => :commentsjson
  # match '/api/api/courses', :to => 'api/api#courses', :as => :coursesjson
  # match '/api/api/users', :to => 'api/api#users', :as => :usersjson
  # match '/api/api/notifications', :to => 'api/api#notifications', :as => :notificationsjson
  # match '/api/api/create_comment', :to => 'api/api#create_comment', :as => :create_comment
end
