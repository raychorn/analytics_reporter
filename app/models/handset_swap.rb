class HandsetSwap < ActiveRecord::Base
  def self.switch_data(connection, period)
    set_table_name "#{period}_handset_swap"
    establish_connection "analytics_#{connection}"
  end
end
