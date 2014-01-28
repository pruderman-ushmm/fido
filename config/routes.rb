Br2::Application.routes.draw do
  # resources :online_books
  get 'online_books' => 'online_books#index'
  get 'online_books/:designation' => 'online_books#show', constraints: { designation: /[-A-Za-z0-9.]+/ }

  get 'online_books/show_thumbnails/:designation/:page_designation' => 'online_books#show_thumbnails', constraints: { designation: /[-A-Za-z0-9.]+/ }
  get 'online_books/show_page/:designation/:page_designation' => 'online_books#show_page', constraints: { designation: /[-A-Za-z0-9.]+/ }
  get 'online_books/zoom_page/:designation/:page_designation' => 'online_books#zoom_page', constraints: { designation: /[-A-Za-z0-9.]+/ }

  # get 'online_pages' => 'online_pages#index'
  # get 'online_pages/:id' => 'online_pages#show'
#  get 'online_pages/:designation' => 'online_books#show', constraints: { designation: /[-A-Za-z0-9.]+/ }

  resources :online_pages

  resources :file_patterns

  resources :digital_assets

  resources :digital_collections

#scope '/br2' do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :collection_components
  resources :component_levels
#end

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
