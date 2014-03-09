PaxTTlib::Application.routes.draw do

    root :to => "checkouts#new"
    
    #match 'games/remove',       to:'games#remove',          via: :get
    #match 'games/remove',       to:'games#remove',          via: :post
    
    match 'signin',             to:'sessions#new',          via: :get
    match 'signout',            to:'sessions#destroy',      via: :delete
    match 'admin',              to:'sessions#index',        via: :get
    match 'metrics',            to:'sessions#metrics',      via: :get
    match 'culls',              to:'sessions#culls',      via: :get

    resources :checkouts
    resources :sessions,        only: [:new, :create, :destroy]
    #resources :users,           only: [:new, :create, :destroy, :index]
    #resources :attendees
    resources :games, :titles, :paxes, :publishers#, :sections

    #mk3    
    match 'is_valid_game', to: 'games#valid_game'
    match 'attendee_by_id', to: 'attendees#get_attendee_by_id'
    
    match 'checkouts/create', to: 'checkouts#create', via: :post
    match 'checkouts/swap', to: 'checkouts#swap', via: :post
    
    match 'return', to: 'checkouts#return', via: :post
    
    match 'attendees/create',   to: 'attendees#create', via: :post

    match 'games/create', to: 'games#create', via: :post
    match 'games/update_section', to: 'games#update_section', via: :post
    
    match 'pax/current', to: 'paxes#set_current', via: :post
    match 'pax/create', to: 'paxes#create', via: :post
    match 'pax/update', to: 'paxes#update', via: :post
    
    match 'sections', to: 'sections#index', via: :get
    match 'sections/create', to: 'sections#create', via: :post
    match 'sections/update', to: 'sections#update', via: :put
    
    match 'game_by_id', to: 'games#get_game_by_id', via: :get
    match 'games/cull', to: 'games#cull', via: :post
    match 'games/activate', to: 'games#activate', via: :post
    match 'games/deactivate', to: 'games#deactivate', via: :post
    
    #resources :sections do
    #  resources :games
    #end

    #resources :publishers do
        #resources :titles
    #end
    
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
    # root :to => 'welcome#index'

    # See how all your routes lay out with "rake routes"

    # This is a legacy wild controller route that's not recommended for RESTful applications.
    # Note: This route will make all actions in every controller accessible via GET requests.
    # match ':controller(/:action(/:id))(.:format)'
end
