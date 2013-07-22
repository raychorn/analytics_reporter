class GeographicProvision < ActiveRecord::Base
  def self.switch_data(connection, period)
    #set_table_name "#{period}_swaps"
    establish_connection "analytics_#{connection}"
  end
end