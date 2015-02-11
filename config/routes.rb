Rails.application.routes.draw do
  
  get 'donate/index'

  get 'donate/new'

  get 'donate/create'

  get 'donate/edit'

  get 'donate/update'

  get 'donate/show'

  get 'donate/delete'

  get 'giftcard/index'

  get 'giftcard/delete'

  get 'giftcard/edit'

  get 'giftcard/new'

  get 'giftcard/show'

  post 'giftcard/create'
  
  get 'merchant/index'

  get 'merchant/create'

  get 'merchant/edit'

  post 'merchant/update'

  get 'merchant/delete'

  get 'merchant/show'

  get 'merchant/new'

  get 'contact/index'

  get 'team/index'

  get 'privacypolicy/index'

  get 'termsconditions/index'

  get 'termsconditions/index_no_layout'

  get 'aboutus/index'

  get 'faq/index'

  get 'howitworks/index'

  get 'cause/index'

  get 'cause/new'

  get 'cause/edit'

  get 'cause/show'

  get 'cause/delete'

  get 'sign_in/index'

  get 'sign_in/resetpassword'

  post 'sign_in/resetpasswordsubmit'

  get 'cause/autocomplete_charity_charityname'

  get 'sign_up/verifyregistration'

  get 'sign_up/resendverifylink'  

  post 'sign_up/resendverifylinksubmit'
  post 'sign_in/recoverpasswordemail'

  post 'home/newslettersignup'

  # for facebook
  get 'auth/:provider/callback', to: 'sign_in#login_facebook'
  get 'auth/failure', to: redirect('/')

  post 'sign_up/create'
  post 'sign_in/login'

  post 'cause/create'
  post 'cause/update'
  post 'donate/create'
  post 'donate/update'
  post 'giftcard/update'
  post '/cause/causeautocomplete'
  post '/merchant/merchantautocomplete'


  root :to => "home#index"
  match ':controller(/:action(/:id))', :via => :get

  match '/:id' => "shortener/shortened_urls#show", :via => :get

  resources :widgets

  if Rails.env.production?
   get '404', :to => 'home#error'
   get '422', :to => 'home#error'
   get '500', :to => 'home#error'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  #root 'welcome#index'

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
