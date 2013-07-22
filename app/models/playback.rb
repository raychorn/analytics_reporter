class Playback < ActiveRecord::Base
  set_table_name "daily_playbacks" 
  establish_connection "analytics"
end
