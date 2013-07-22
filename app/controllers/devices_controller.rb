class DevicesController < ApplicationController
  # GET /devices
  # GET /devices.xml
  def index
    if params[:period]
      Device.switch_data(params[:connection], params[:period])
    else
      Device.switch_data(params[:connection], "daily")
    end
    from_date = params[:startdate] ? params[:startdate] : 1.months.ago.utc.strftime("%Y-%m-%d")
    to_date = params[:enddate] ? params[:enddate] : Time.now.utc.strftime("%Y-%m-%d")
    @devices = Device.find(:all, :select => "server_make, server_model ,SUM(server_count) AS view_count,AVG(server_total-server_count) AS avg_raiting", :group => "server_make,server_model", :conditions => ["server_date >= ? and server_date <= ?",
                                                          from_date,to_date])
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @devices.to_xml(:root => 'records', :children => 'record', :dasherize => false, :skip_types => true) }
    end
  end
  
  # GET /devices/1
  # GET /devices/1.xml
  def show
    @devices = Device.find(params[:id])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @devices.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
    end
  end
  
  # GET /devices/2009/1/1
  # GET /devices/2009/1/1.xml
  def find_by_date
    Device.switch_table("daily")
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    if (params[:device])
      @devices = Device.find(:all, :conditions => ["day(server_date) =? and month(server_date) =? and year(server_date) =? AND server_model LIKE ?", params[:day], params[:month], params[:year], "%" + params[:device] + "%"])
    else 
      @devices = Device.find(:all, :conditions => ["day(server_date) =? and month(server_date) =? and year(server_date) =?", params[:day], params[:month], params[:year]])
    end
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @devices.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
    end
  end
  
  # GET /devices/daily/2009/1
  # GET /devices/daily/2009/1.xml
  # GET /devices/daily/2009/1.xls
  # GET /devices/daily/2009/1.csv
  # GET /devices/monthly/2009/1
  # GET /devices/monthly/2009/1.xml
  # GET /devices/monthly/2009/1.xls
  # GET /devices/monthly/2009/1.csv
  def find_by_month
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    if params[:period] == "monthly"
      Device.switch_table("monthly")
      @devices = Device.find(:all, :conditions => ["server_date =? and server_year =?", params[:month],params[:year]])
    else
      Device.switch_table("daily")
      @devices = Device.find(:all, :conditions => ["month(server_date) =? and year(server_date) =?", params[:month], params[:year]])
    end
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @devices.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
      format.xls { send_data @devices.to_xls }
      format.csv { send_data @devices.to_csv }
    end
  end
end
