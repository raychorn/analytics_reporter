class SystemsController < ApplicationController
  
  before_filter :login_required
  
  # GET /systems
  # GET /systems.xml
  def index
    @systems = System.find :all    
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @systems.to_xml(:dasherize => false) }
    end
  end
  
  # GET /systems/1
  # GET /systems/1.xml
  def show
    @systems = System.find(params[:id])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @systems.to_xml(:dasherize => false) }
    end
  end
  
  # GET /systems/2009/1/1
  # GET /systems/2009/1/1.xml
  def find_by_date
    System.switch_table("daily")
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    @systems = System.find(:all, :conditions => ["day(server_date) =? and month(server_date) =? and year(server_date) =?", params[:day], params[:month], params[:year]])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @systems.to_xml(:dasherize => false) }
    end
  end
  
  # GET /systems/daily/2009/1
  # GET /systems/daily/2009/1.xml
  # GET /systems/daily/2009/1.xls
  # GET /systems/daily/2009/1.csv
  # GET /systems/monthly/2009/1
  # GET /systems/monthly/2009/1.xml
  # GET /systems/monthly/2009/1.xls
  # GET /systems/monthly/2009/1.csv
  def find_by_month
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    if params[:period] == "monthly"
      System.switch_table("monthly")
      @systems = System.find(:all, :conditions => ["server_date =? and server_year =?", params[:month],params[:year]])
    else
      System.switch_table("daily")
      @systems = System.find(:all, :conditions => ["month(server_date) =? and year(server_date) =?", params[:month], params[:year]])
    end
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @systems.to_xml(:dasherize => false) }
      format.xls { send_data @systems.to_xls }
      format.csv { send_data @systems.to_csv }
    end
  end
end
