class IpsController < ApplicationController
  # GET /ips
  # GET /ips.xml
  def index
    @ips = Ip.find :all    
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @ips.to_xml(:dasherize => false) }
    end
  end
  
  # GET /ips/1
  # GET /ips/1.xml
  def show
    @ips = Ip.find(params[:id])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @ips.to_xml(:dasherize => false) }
    end
  end
  
  # GET /ips/2009/1/1
  # GET /ips/2009/1/1.xml
  def find_by_date
    Ip.switch_table("daily")
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    @ips = Ip.find(:all, :limit => 50, :conditions => ["day(server_date) =? and month(server_date) =? and year(server_date) =?", params[:day], params[:month], params[:year]])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @ips.to_xml(:dasherize => false) }
    end
  end
  
  # GET /ips/daily/2009/1
  # GET /ips/daily/2009/1.xml
  # GET /ips/daily/2009/1.xls
  # GET /ips/daily/2009/1.csv
  # GET /ips/monthly/2009/1
  # GET /ips/monthly/2009/1.xml
  # GET /ips/monthly/2009/1.xls
  # GET /ips/monthly/2009/1.csv
  def find_by_month
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    if params[:period] == "monthly"
      Ip.switch_table("monthly")
      @ips = Ip.find(:all, :conditions => ["server_date =? and server_year =?", params[:month],params[:year]])
    else
      Ip.switch_table("daily")
      @ips = Ip.find(:all, :conditions => ["month(server_date) =? and year(server_date) =?", params[:month], params[:year]])
    end
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @ips.to_xml(:dasherize => false) }
      format.xls { send_data @ips.to_xls }
      format.csv { send_data @ips.to_csv }
    end
  end
end
