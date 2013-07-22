class HandsetSwapsController < ApplicationController
  # GET /handsetswaps/:handswap
  # GET /handsetswaps/:handswap.xml
  def index
    if params[:period]
      HandsetSwap.switch_data(params[:connection], params[:period])
    else
      HandsetSwap.switch_data(params[:connection], "daily")
    end
    hand_set_from = params[:hand_set_from] ? params[:hand_set_from] : "%"
    hand_set_to = params[:hand_set_to] ? params[:hand_set_to] : "%"
    from_date = params[:startdate] ? params[:startdate] : 1.months.ago.utc.strftime("%Y-%m-%d")
    to_date = params[:enddate] ? params[:enddate] : Time.now.utc.strftime("%Y-%m-%d")
    @handsetswaps = HandsetSwap.find(:all, :select => "server_date ,SUM(server_count) AS view_count", :group => "server_date", :conditions => ["server_date >= ? and server_date <= ? and hand_set_from LIKE ? and hand_set_to LIKE ?",
                                                          from_date,to_date,hand_set_from,hand_set_to]) 
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @handsetswaps.to_xml(:root => 'records', :children => 'record', :dasherize => false, :skip_types => true) }
    end
  end
  
  # GET /handsetswaps/:handswap/1
  # GET /handsetswaps/:handswap/1.xml
  def show
    HandsetSwap.switch_data(params[:handswap], "daily")
    @handsetswaps = HandsetSwap.find(:all, :group => "server_date", :conditions => ["server_deviceid =?", params[:id]])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @handsetswaps.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
    end
  end
  
  # GET /handsetswaps/:handswap/2009/1/1
  # GET /handsetswaps/:handswap/2009/1/1.xml
  def find_by_date
    HandsetSwap.switch_data(params[:handswap], "daily")
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    vpn = params[:vpn] ? params[:vpn] : "%"
    type = params[:type] ? params[:type] : "%"
    deviceid = params[:device] ? params[:device] : "%"
    @handsetswaps = HandsetSwap.find(:all, :conditions => ["day(server_date) =? and month(server_date) =? and year(server_date) =? and server_vpn LIKE ? and server_type LIKE ? and server_deviceid LIKE ?", 
                                                          params[:day], params[:month], params[:year],vpn,type,deviceid])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @handsetswaps.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
    end
  end
  
  # GET /handsetswaps/:handswap/daily/2009/1
  # GET /handsetswaps/:handswap/daily/2009/1.xml
  # GET /handsetswaps/:handswap/daily/2009/1.xls
  # GET /handsetswaps/:handswap/daily/2009/1.csv
  # GET /handsetswaps/:handswap/monthly/2009/1
  # GET /handsetswaps/:handswap/monthly/2009/1.xml
  # GET /handsetswaps/:handswap/monthly/2009/1.xls
  # GET /handsetswaps/:handswap/monthly/2009/1.csv
  def find_by_month
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    vpn = params[:vpn] ? params[:vpn] : "%"
    type = params[:type] ? params[:type] : "%"
    deviceid = params[:device] ? params[:device] : "%"
    if params[:period] == "monthly"
      HandsetSwap.switch_data(params[:handswap], "monthly")
      @handsetswaps = HandsetSwap.find(:all, :conditions => ["server_date =? and server_year =? and server_vpn LIKE ? and server_type LIKE ? and server_deviceid LIKE ?", 
                                                            params[:month],params[:year],vpn,type,deviceid])
    else
      HandsetSwap.switch_data(params[:handswap], "daily")
      @handsetswaps = HandsetSwap.find(:all, :conditions => ["month(server_date) =? and year(server_date) =? and server_vpn LIKE ? and server_type LIKE ? and server_deviceid LIKE ?", 
                                                            params[:month], params[:year],vpn,type,deviceid])
    end
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @handsetswaps.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
      format.xls { send_data @handsetswaps.to_xls }
      format.csv { send_data @handsetswaps.to_csv }
    end
  end
end
