class Zoom < ActiveRecord::Base
  set_table_name "daily_zooms" 
  establish_connection "analytics"
end
