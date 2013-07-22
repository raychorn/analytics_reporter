class Ip < ActiveRecord::Base
  set_table_name "daily_ip" 
  establish_connection "analytics"
  
  def self.switch_table(period)
    set_table_name "#{period}_ip"
    establish_connection "analytics"
  end
  
  def self.switch_data(connection, period)
    set_table_name "#{period}_ip"
    establish_connection "analytics_#{connection}"
  end
end
