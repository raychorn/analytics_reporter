class Analytics < ActiveRecord::Base
  set_table_name "result_event_count" 
  establish_connection "analytics"
end