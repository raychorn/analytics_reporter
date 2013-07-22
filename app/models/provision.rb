class Provision < ActiveRecord::Base
  def self.switch_data(connection, period)
    set_table_name "#{period}_provisions"
    establish_connection "analytics_#{connection}"
  end
end
