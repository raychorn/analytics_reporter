class Id < ActiveRecord::Base
  set_table_name "daily_id" 
  establish_connection "analytics"
end
