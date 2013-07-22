class Vttandroiddetail < ActiveRecord::Base
  def self.switch_data(connection, period)
    set_table_name "#{period}_vtt_android_details"
    establish_connection "analytics_#{connection}"
  end
end
