Rails.application.routes.draw do

  # Devise routes for API clients (custom sessions controller)
  devise_scope :user do
    post 'v1/signup', to: 'users/registrations#create'
    put    'v1/verify', to: 'users/registrations#verify'
    post 'v1/signin', to: 'users/sessions#create'
    delete 'v1/signout', to: 'users/sessions#destroy'
    post 'v1/pw_recover', to: 'users/passwords#recover'
    post 'v1/pw_update', to: 'users/passwords#update'
    post 'v1/delete', to: 'users/registrations#delete'
  end

  # Devise routes for web clients (built-in sessions controller)
  devise_for :users

  # For API through browser
  resources :users

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
end
