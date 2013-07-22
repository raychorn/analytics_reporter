class Transfer < ActiveRecord::Base
  set_table_name "daily_transfers" 
  establish_connection "analytics"
end
