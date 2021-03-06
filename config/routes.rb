Rails.application.routes.draw do
	get ':controller(/:action)', controller: /[^\/]+/, action: /stats/

  resources :pedidos, except: [:edit, :update] do
		resources :pedidos_cantidades, except: [:index, :show]
	end

	get 'pedidos/:id/recibir', to: 'pedidos#recibir', as: 'recibir_pedido'
  get 'pedidos/:id/place', to: 'pedidos#place', as: 'place_pedido'

  resources :ordenes do
		resources :ordenes_cantidades, except: [:index, :show]
	end

  get 'ordenes/:id/place', to: 'ordenes#place', as: 'place_orden'
  get 'ordenes/:id/asignar_repartidor', to: 'ordenes#asignar_repartidor', as: 'asignar_repartidor'
	patch 'ordenes/:id/update_repartidor', to: 'ordenes#update_repartidor', as: 'update_repartidor'
  get 'ordenes/:id/entregar', to: 'ordenes#entregar', as: 'entregar_orden'

  resources :repartidores

  resources :clientes do
		resources :tiendas_clientes, shallow: true
  end

  resources :relojes

  resources :vendedores

  resources :proveedores

  devise_for :users, :skip => [:registrations]                                          
	as :user do
		get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'    
		patch 'users/:id' => 'devise/registrations#update', :as => 'user_registration'            
	end

	post 'ordenes/update_tiendas', as: 'update_tiendas'
	post 'ordenes_cantidades/update_relojes', as: 'update_relojes'
  get 'reparto', to: 'reparto#index', as: 'reparto'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#inicio'

	# Redirect to root if no route matches
	get '*path' => redirect('/')

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
