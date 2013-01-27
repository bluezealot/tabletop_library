PaxTTlib::Application.routes.draw do

    root :to => "checkouts#index"
    
    match 'attendees/info',     to:'attendees#info_get', via: :get
    match 'attendees/info',     to:'attendees#info_post', via: :post
    
    match 'games/info',         to:'games#info_get', via: :get
    match 'games/info',         to:'games#info_post', via: :post
    match 'games/remove',       to:'games#remove', via: :get
    match 'games/remove',       to:'games#remove', via: :post
    
    match 'checkouts/game',     to:'checkouts#game_get', via: :get
    match 'checkouts/game',     to:'checkouts#game_post', via: :post
    match 'checkouts/swap',     to:'checkouts#swap', via: :post
    
    match 'returns/new',        to:'returns#new', via: :get
    match 'returns/attendee',   to:'returns#create', via: :post
    
    match 'returns/confirm',    to:'returns#show', via: :get
    match 'returns/confirm',    to:'returns#confirm', via: :post
    
    match 'signin',             to:'sessions#new', via: :get
    match 'signout',            to:'sessions#destroy', via: :delete
    match 'admin',              to:'sessions#index', via: :get

    match 'loaners/add_game',   to:'loaners#add_game', via: :get
            
    resources :sessions,        only: [:new, :create, :destroy]
    resources :users,           only: [:new, :create, :destroy, :index]
    resources :checkouts, :attendees, :games, :titles, :paxes, :loaners
    
    resources :sections do
      resources :games
    end

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
