class Usage < ActiveRecord::Base
  def self.switch_data(connection, period)
    set_table_name "#{period}_usage"
    establish_connection "analytics_#{connection}"
  end
  
  def self.generateReport(period)
    
  end
end
