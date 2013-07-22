class UsagesController < ApplicationController
  
  before_filter :login_required
  
  # GET /usages/:Usage
  # GET /usages/:Usage.xml
  def index
    if params[:period]
      Usage.switch_data(params[:connection], params[:period])
    else
      Usage.switch_data(params[:connection], "daily")
    end
    from_date = params[:startdate] ? params[:startdate] : 1.months.ago.utc.strftime("%Y-%m-%d")
    to_date = params[:enddate] ? params[:enddate] : Time.now.utc.strftime("%Y-%m-%d")
    @usages = Usage.find(:all, :select => "server_date,server_usage,G4,G3", :group => "server_usage", :order => "id", :conditions => ["server_date >= ? and server_date <= ?",
                                                          from_date,to_date])    
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @usages.to_xml(:root => 'records', :children => 'record', :dasherize => false, :skip_types => true) }
    end
  end
  
  # GET /usages/:Usage/1
  # GET /usages/:Usage/1.xml
  def show
    Usage.switch_data(params[:Usage], "daily")
    @usages = Usage.find(params[:id])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @usages.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
    end
  end
  
  # GET /usages/:Usage/2009/1/1
  # GET /usages/:Usage/2009/1/1.xml
  def find_by_date
    Usage.switch_data(params[:connection], "daily")
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    vpn = params[:vpn] ? params[:vpn] : "%"
    type = params[:type] ? params[:type] : "%"
    @usages = Usage.find(:all, :conditions => ["day(server_date) =? and month(server_date) =? and year(server_date) =? and server_vpn LIKE ? and server_type LIKE ?", 
                                                          params[:day], params[:month], params[:year],vpn,type])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @usages.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
    end
  end
  
  # GET /usages/:Usage/daily/2009/1
  # GET /usages/:Usage/daily/2009/1.xml
  # GET /usages/:Usage/daily/2009/1.xls
  # GET /usages/:Usage/daily/2009/1.csv
  # GET /usages/:Usage/monthly/2009/1
  # GET /usages/:Usage/monthly/2009/1.xml
  # GET /usages/:Usage/monthly/2009/1.xls
  # GET /usages/:Usage/monthly/2009/1.csv
  def find_by_month
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    vpn = params[:vpn] ? params[:vpn] : "%"
    type = params[:type] ? params[:type] : "%"
    if params[:period] == "monthly"
      Usage.switch_data(params[:connection], "monthly")
      @usages = Usage.find(:all, :conditions => ["server_date =? and server_year =? and server_vpn LIKE ? and server_type LIKE ?", 
                                                            params[:month],params[:year],vpn,type])
    else
      Usage.switch_data(params[:connection], "daily")
      @usages = Usage.find(:all, :conditions => ["month(server_date) =? and year(server_date) =? and server_vpn LIKE ? and server_type LIKE ?", 
                                                            params[:month], params[:year],vpn,type])
    end
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @usages.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
      format.xls { send_data @usages.to_xls }
      format.csv { send_data @usages.to_csv }
    end
  end
end
