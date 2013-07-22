class AnalyticsController < ApplicationController
  def index
    @analytics = Analytics.find(:all)
    render :xml => @analytics.to_xml(:dasherize => false)
  end
  
  def event
    @analytics = Analytics.find(:all, :group => "server_date", :conditions => ["server_event =?", params[:id]])
    render :xml => @analytics.to_xml(:dasherize => false)
  end
  
  def by_date
    @analytics = Analytics.find(:all, :group => "server_date")
    xml = Builder::XmlMarkup.new(:indent => 1)
    xml.instruct!
    xml.analytics do
      @analytics.each do |a|
        xml.analytic("date"=>a.server_date) do
          @analytics_by_date = Analytics.find(:all, :conditions => ["server_date = ?", a.server_date])
          @analytics_by_date.each do |b|
            #xml.server_event b.server_event
            #xml.tag!("server_event_" + b.server_event.to_s)
            case b.server_event
            when 1
              xml.server_event_1 b.server_count
            when 2
              xml.server_event_2 b.server_count
            when 3
              xml.server_event_3 b.server_count
            when 4
              xml.server_event_4 b.server_count
            when 5
              xml.server_event_5 b.server_count
            when 6
              xml.server_event_6 b.server_count
            when 7
              xml.server_event_7 b.server_count
            when 8
              xml.server_event_8 b.server_count
            when 9
              xml.server_event_9 b.server_count
            when 10
              xml.server_event_10 b.server_count
            else
              puts "Event Number Error, Please Correct!"
            end
          end
        end
      end
    end
    render :xml => xml.target!
  end
end