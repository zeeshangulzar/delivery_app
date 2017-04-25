Rails.application.routes.draw do

  resources :time_slots do
    collection do
      post 'import', to: 'time_slots#import'
      get 'download_template'
    end
  end
  # Devise routes for API clients (custom sessions controller)
  devise_scope :user do
    post 'v1/signup', to: 'users/registrations#create'
    put 'v1/update_profile', to: 'users/registrations#update_profile'
    put    'v1/verify', to: 'users/registrations#verify'
    post 'v1/signin', to: 'users/sessions#create'
    delete 'v1/signout', to: 'users/sessions#destroy'
    post 'v1/pw_recover', to: 'users/passwords#recover'
    post 'v1/pw_update', to: 'users/passwords#update'
    post 'v1/delete', to: 'users/registrations#delete'
    post 'v1/user_saved_location', to: 'locations#save_user_location'
    delete 'v1/user_deleted_location', to: 'locations#delete_user_location'
    post 'v1/user_updated_location', to: 'locations#update_user_location'
    get 'v1/status_code', to: 'settings#status_code'
    get 'v1/configurations', to: 'settings#configuration'
    post 'v1/guest_verify', to: 'users/registrations#guest_verify'
    post 'v1/save_booking', to: 'bookings#save_booking'
    get 'v1/user_bookings', to: 'bookings#list'
    get 'v1/user_orders', to: 'bookings#orders_list'
  end

  get 'v1/daily_time_slots', to: 'time_slots#daily_time_slots'
  get 'v1/user_get_location', to: 'locations#get_user_location'

  get 'v1/track_order', to: 'orders#track_order'

  get 'home', to: 'home#index'

  # Devise routes for web clients (built-in sessions controller)
  devise_for :users

  # For API through browser
  resources :users do
    collection do
      get 'list/:role/:status', to: 'users#users_by_role', as: 'user_by_role'
      post 'save_driver'
      post 'update_driver'
    end

    member do
      post 'update_status'
    end
  end
  resources :bookings, only: [:show, :index, :destroy]
  resources :configs
  resources :orders, only: [:show, :index]
  resources :questions

  get 'map' => 'map#map'
  delete 'delete_map' => 'map#destroy'
  get 'save_polygon' => 'map#save_polygon'
  post 'update_polygon' => 'map#update_polygon'
  get 'v1/service_areas', to: 'map#service_areas'

  post 'v1/booking_payment', to: 'payments#booking_payment'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  devise_scope :user do
    root to: "devise/sessions#new"
  end
end
