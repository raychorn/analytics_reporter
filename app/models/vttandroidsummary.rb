class Vttandroidsummary < ActiveRecord::Base
  def self.switch_data(connection, period)
    set_table_name "#{period}_vtt_android_summary"
    establish_connection "analytics_#{connection}"
  end
end
