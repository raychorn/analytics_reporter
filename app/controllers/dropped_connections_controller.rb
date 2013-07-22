class DroppedConnectionsController < ApplicationController
  # GET /connections/:connection
  # GET /connections/:connection.xml
  def index
    if params[:period]
      DroppedConnection.switch_data(params[:connection], params[:period])
    else
      DroppedConnection.switch_data(params[:connection], "daily")
    end
    vpn = params[:vpn] ? params[:vpn] : "%"
    type = params[:type] ? params[:type] : "%"
    deviceid = params[:device] ? params[:device] : "%"
    @connections = DroppedConnection.find(:all, :conditions => ["server_vpn LIKE ? and server_type LIKE ? and server_deviceid LIKE ?",vpn,type,deviceid])    
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @connections.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
    end
  end
  
  # GET /connections/:connection/1
  # GET /connections/:connection/1.xml
  def show
    DroppedConnection.switch_data(params[:connection], "daily")
    @connections = DroppedConnection.find(:all, :group => "server_date", :conditions => ["server_deviceid =?", params[:id]])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @connections.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
    end
  end
  
  # GET /connections/:connection/2009/1/1
  # GET /connections/:connection/2009/1/1.xml
  def find_by_date
    DroppedConnection.switch_data(params[:connection], "daily")
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    vpn = params[:vpn] ? params[:vpn] : "%"
    type = params[:type] ? params[:type] : "%"
    deviceid = params[:device] ? params[:device] : "%"
    @connections = DroppedConnection.find(:all, :conditions => ["day(server_date) =? and month(server_date) =? and year(server_date) =? and server_vpn LIKE ? and server_type LIKE ? and server_deviceid LIKE ?", 
                                                          params[:day], params[:month], params[:year],vpn,type,deviceid])
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
    deviceid = params[:device] ? params[:device] : "%"
    if params[:period] == "monthly"
      DroppedConnection.switch_data(params[:connection], "monthly")
      @connections = DroppedConnection.find(:all, :conditions => ["server_date =? and server_year =? and server_vpn LIKE ? and server_type LIKE ? and server_deviceid LIKE ?", 
                                                            params[:month],params[:year],vpn,type,deviceid])
    else
      DroppedConnection.switch_data(params[:connection], "daily")
      @connections = DroppedConnection.find(:all, :conditions => ["month(server_date) =? and year(server_date) =? and server_vpn LIKE ? and server_type LIKE ? and server_deviceid LIKE ?", 
                                                            params[:month], params[:year],vpn,type,deviceid])
    end
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @connections.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
      format.xls { send_data @connections.to_xls }
      format.csv { send_data @connections.to_csv }
    end
  end
end