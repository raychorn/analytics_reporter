ActionController::Routing::Routes.draw do |map|
  map.resources :vttandroidsummaries

  map.resources :vttandroiddetails

  map.resources :provisions

  map.resources :swaps

  map.resources :handset_swaps

  map.resources :usages

  map.resources :signal_strengths

  map.resources :dropped_connections

  map.resources :connections

  map.resources :ids

  map.resources :ips

  map.resources :zooms, :only => [:index]

  map.resources :devices, :only => [:index]

  map.resources :transfers, :only => [:index]

  map.resources :playbacks, :only => [:index]

  map.resources :zooms, :only => [:index]
      
  map.resources :systems, :only => [:index]
  
  map.resources :events, :only => [:index]
  
  map.resources :users
  
  map.resource :session
  
  map.geoip '/geoip', :controller => 'geoip', :action => 'index', :method => 'post'
  map.events '/events/pdf/:year/:month', :controller => 'events', :action => 'pdf', :year => /\d{4}/, :month => /\d{1,2}/
  
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.login '/login.mobile', :controller => 'sessions', :action => 'new', :format => 'mobile'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.index '/', :controller => "events", :action => "index"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:connection/:year/:month/:day',
              :action     => 'find_by_date',
              :connection => /vvm|verizon|connectivity|vtt/,
              :year       => /\d{4}/,
              :month      => /\d{1,2}/,
              :day        => /\d{1,2}/
  map.connect ':controller/:connection/:year/:month/:day.:format',
              :action     => 'find_by_date',
              :connection => /vvm|verizon|connectivity|vtt/,
              :year       => /\d{4}/,
              :month      => /\d{1,2}/,
              :day        => /\d{1,2}/
  map.connect ':controller/:connection/:period/:year/:month',
              :action     => 'find_by_month',
              :connection => /vvm|verizon|connectivity|vtt/,
              :period     => /daily|monthly|weekly/,
              :year       => /\d{4}/,
              :month      => /\d{1,2}/
  map.connect ':controller/:connection/:period/:year/:month.:format',
              :action     => 'find_by_month',
              :connection => /vvm|verizon|connectivity|vtt/,
              :period     => /daily|monthly|weekly/,
              :year       => /\d{4}/,
              :month      => /\d{1,2}/
  map.connect ':controller/:connection/:period/:year',
              :action     => 'find_by_year',
              :connection => /vvm|verizon|connectivity|vtt/,
              :period     => /daily|monthly|weekly/,
              :year       => /\d{4}/
  map.connect ':controller/:connection/:period/:year.:format',
              :action     => 'find_by_year',
              :connection => /vvm|verizon|connectivity|vtt/,
              :period     => /daily|monthly|weekly/,
              :year       => /\d{4}/
  # ex: swaps/vvm/daily.xml
  map.connect ':controller/:connection/:period',
              :action     => 'index',
              :connection => /vvm|verizon|connectivity|vtt/,
              :period     => /daily|monthly|weekly/
  map.connect ':controller/:connection/:period.:format',
               :action     => 'index',
               :connection => /vvm|verizon|connectivity|vtt/,
               :period     => /daily|monthly|weekly/
 
  #map.connect ':controller/:id',
  #            :action     => 'show'
  #map.connect ':controller/:id.:format',
  #            :action     => 'show'
  
  # ex: dataSource="/swaps/vvm/daily/1
  map.connect ':controller/:connection/:period/:id',
              :action     => 'show',
              :connection => /vvm|verizon|connectivity|vtt/,
              :period     => /daily|monthly|weekly/
  # ex: dataSource="/swaps/vvm/daily/1.xml
  map.connect ':controller/:connection/:period/:id.:format',
              :action     => 'show',
              :connection => /vvm|verizon|connectivity|vtt/,
              :period     => /daily|monthly|weekly/
              
  # ex: dataSource="/swaps/vvm/daily/handset_type/from_handset_type.xml
  # action - handset_type, id = from_handset_type
  # ex: dataSource="/swaps/vvm/daily/handset_type/to_handset_type.xml
  # action - handset_type, id = to_handset_type
  map.connect ':controller/:connection/:period/:action/:id.:format',
              :connection => /vvm|verizon|connectivity|vtt/,
              :period     => /daily|monthly|weekly/
              
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
