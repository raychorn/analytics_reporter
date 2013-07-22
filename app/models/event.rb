class Event < ActiveRecord::Base
  set_table_name "daily_events" 
  establish_connection "analytics"
  
  def self.switch_table(period)
    set_table_name "#{period}_events"
    establish_connection "analytics"
  end
  
  def self.switch_data(connection, period)
    set_table_name "#{period}_events"
    establish_connection "analytics_#{connection}"
  end
  
  def self.generateReport(period)
    
  end
end
