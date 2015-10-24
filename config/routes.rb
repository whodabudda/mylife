Rails.application.routes.draw do
  resources :duser_metrics
  resources :units
  resources :metrics
  #devise_for :dusers, controllers: {
  #  sessions: "dusers/sessions"
 # }

  #devise_for :dusers, :skip => [:sessions]
  #as :duser do
  #  get 'signin' => 'devise/sessions#new', :as => 'welcome#greeting'
  #  get 'signup' => 'devise/registrations#new', :as => 'welcome#greeting'
 # end
  devise_for :dusers
  #as :duser do
  #get 'welcome/sign_in', to: 'welcome#greeting', defaults: {orig_action: 'sign_in'}
  #get 'welcome/sign_up', to: 'welcome#greeting', defaults: {orig_action: 'sign_up'}
  #delete 'dusers/sign_out', to: 'devise/sessions#destroy'
  #devise_for :duser, :path => '', :path_names => { :sign_in => "welcome/sign_in", :sign_up => "welcome/sign_up" }

  get 'welcome/greeting'
  #get 'welcome/sign_in'
  #get 'welcome/sign_up'
  get 'welcome/about'

  get 'welcome/doc'
  get 'welcome/home'

  get 'metric/add'

  get 'metric/edit'

  get 'metric/delete'

 # get 'user/login'

 # get 'user/logout'

 # get 'user/new'

 # get 'user/forgot_pw'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#greeting'

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
