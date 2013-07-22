class DroppedConnection < ActiveRecord::Base
  def self.switch_data(connection, period)
    set_table_name "#{period}_dropped_connections"
    establish_connection "analytics_#{connection}"
  end
  
  def self.generateReport(period)
    
  end
end