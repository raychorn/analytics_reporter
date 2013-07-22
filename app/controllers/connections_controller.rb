class ConnectionsController < ApplicationController
  
  before_filter :login_required
  
  # GET /connections/:connection
  # GET /connections/:connection.xml
  def index
    if params[:period]
      Connection.switch_data(params[:connection], params[:period])
    else
      Connection.switch_data(params[:connection], "daily")
    end
    vpn = params[:vpn] ? params[:vpn] : "%"
    type = params[:type] ? params[:type] : "%"
    from_date = params[:startdate] ? params[:startdate] : 1.months.ago.utc.strftime("%Y-%m-%d")
    to_date = params[:enddate] ? params[:enddate] : Time.now.utc.strftime("%Y-%m-%d")
    @connections = Connection.find(:all, :select => "server_date ,SUM(server_count) AS view_count", :group => "server_date", :conditions => ["server_date >= ? and server_date <= ? and server_vpn LIKE ? and server_type LIKE ?",
                                                          from_date,to_date,vpn,type])    
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @connections.to_xml(:root => 'records', :children => 'record', :dasherize => false, :skip_types => true) }
    end
  end
  
  # GET /connections/:connection/1
  # GET /connections/:connection/1.xml
  def show
    Connection.switch_data(params[:connection], "daily")
    @connections = Connection.find(params[:id])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @connections.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
    end
  end
  
  # GET /connections/:connection/2009/1/1
  # GET /connections/:connection/2009/1/1.xml
  def find_by_date
    Connection.switch_data(params[:connection], "daily")
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    vpn = params[:vpn] ? params[:vpn] : "%"
    type = params[:type] ? params[:type] : "%"
    @connections = Connection.find(:all, :conditions => ["day(server_date) =? and month(server_date) =? and year(server_date) =? and server_vpn LIKE ? and server_type LIKE ?", 
                                                          params[:day], params[:month], params[:year],vpn,type])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @connections.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
    end
  end
  
  # GET /connections/:connection/daily/2009/1
  # GET /connections/:connection/daily/2009/1.xml
  # GET /connections/:connection/daily/2009/1.xls
  # GET /connections/:connection/daily/2009/1.csv
  # GET /connections/:connection/monthly/2009/1
  # GET /connections/:connection/monthly/2009/1.xml
  # GET /connections/:connection/monthly/2009/1.xls
  # GET /connections/:connection/monthly/2009/1.csv
  def find_by_month
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    vpn = params[:vpn] ? params[:vpn] : "%"
    type = params[:type] ? params[:type] : "%"
    if params[:period] == "monthly"
      Connection.switch_data(params[:connection], "monthly")
      @connections = Connection.find(:all, :conditions => ["server_date =? and server_year =? and server_vpn LIKE ? and server_type LIKE ?", 
                                                            params[:month],params[:year],vpn,type])
    else
      Connection.switch_data(params[:connection], "daily")
      @connections = Connection.find(:all, :conditions => ["month(server_date) =? and year(server_date) =? and server_vpn LIKE ? and server_type LIKE ?", 
                                                            params[:month], params[:year],vpn,type])
    end
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @connections.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
      format.xls { send_data @connections.to_xls }
      format.csv { send_data @connections.to_csv }
    end
  end
end