MedSafeLabs::Application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  root :to => 'home#index'
  
  # for now prevent users from signing up - they must be invited
  get '/users/sign_up' => 'home#index'
  
  devise_for :users
    
  scope '/admin' do # scope the user admin pages so they don't conflict with devise
    resources :users do
      resources :orders
      resources :tests
    end
    resources :invitations
    resources :administrators
    resources :strains
    resources :qr_codes do
      collection do 
        post :import
        get :print_new_codes 
        get :print_existing_codes 
      end
    end
  end
  
  get '/dashboard' => 'dashboard#index'
  get '/qr/:id' => 'qr#index'
  get '/admin/qr_codes/print_codes' => 'qr_codes#print_codes'
  get '/admin/qr_codes/image/:id' => 'qr_codes#image'
  get '/admin/users/:id/reinvite', to: 'users#reinvite', as: :reinvite
  get '/admin/users/:id/reactivate', to: 'users#reactivate', as: :reactivate
  get '/admin/administrators/:id/reactivate', to: 'administrators#reactivate', as: :reactivate_administrator
  
  resources :results, :purchases, :strains

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
