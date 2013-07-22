class Device < ActiveRecord::Base
  set_table_name "daily_devices" 
  establish_connection "analytics"
  
  def self.switch_table(period)
    set_table_name "#{period}_devices"
    establish_connection "analytics"
  end
  
  def self.switch_data(connection, period)
    set_table_name "#{period}_devices"
    establish_connection "analytics_#{connection}"
  end
end
