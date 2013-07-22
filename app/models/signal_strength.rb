class SignalStrength < ActiveRecord::Base
  acts_as_mappable
  def self.switch_data(connection, period)
    #set_table_name "daily_signals"
    establish_connection "analytics_#{connection}"
  end
end
