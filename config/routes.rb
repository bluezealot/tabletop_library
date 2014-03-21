PaxTTlib::Application.routes.draw do

    root :to => "checkouts#new"
    
    match 'signin',             to: 'sessions#new',          via: :get
    match 'signout',            to: 'sessions#destroy',      via: :delete
    match 'admin',              to: 'sessions#index',        via: :get
    match 'metrics',            to: 'sessions#metrics',      via: :get
    match 'culls',              to: 'sessions#culls',      via: :get

    resources :checkouts
    resources :sessions, only: [:new, :create, :destroy]
    resources :games, :paxes, :publishers

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
    
    match '/status', to: 'application#general_status', via: :get
    match '/backup_database', to: 'application#backup_database', via: :post
    
end