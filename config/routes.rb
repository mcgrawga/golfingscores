Rails.application.routes.draw do

  #
  #  These next two didn't work together.  Was trying to override the devise registrations controller.
  #  The only thing I could get to work was the third uncommented line.
  #
  #devise_for :users, controllers: { registrations: 'users/registrations' }
  #devise_for :users, :skip => [:registrations ]
  devise_for :users, controllers: { sessions: "devise/sessions", passwords: "devise/passwords", registrations: "users/registrations" }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'staticpages#index'
  get 'about' => 'staticpages#about'

  #get 'scores' => 'scores#index'
  #get 'scores/new' => 'scores#new'

  #get 'courses' => 'courses#show'
  #get 'courses/new' => 'courses#new'
  #post 'courses' => 'courses#create'
  #patch 'course' => 'courses#update'
  #get 'courses/edit/:id' => 'courses#edit'
  resources :scores
  get 'scores/get_tees_for_course/:id' => 'scores#get_tees_for_course'
  get 'scores/get_tee/:id' => 'scores#get_tee'
  resources :courses do
    resources :tees
  end

  get 'settings' => 'settings#show'
  get 'settings/change_subscription' => 'settings#change_subscription'
  post 'settings/change_subscription' => 'settings#do_change_subscription'
  get 'settings/cancel_subscription' => 'settings#cancel_subscription'
  post 'settings/cancel_subscription' => 'settings#do_cancel_subscription'
  get 'settings/renew_subscription' => 'settings#renew_subscription'
  post 'settings/renew_subscription' => 'settings#do_renew_subscription'
  

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
