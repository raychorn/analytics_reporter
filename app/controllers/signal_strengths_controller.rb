class SignalStrengthsController < ApplicationController
  
  before_filter :login_required
  
  # GET /signal_strengths/:connection
  # GET /signal_strengths/:connection.xml
  def index
    if params[:period]
      SignalStrength.switch_data(params[:connection], params[:period])
    else
      SignalStrength.switch_data(params[:connection], "daily")
    end
    signal = params[:signal] ? params[:signal] : "%"
    @signal_strengths = SignalStrength.find(:all, :conditions => ["server_signal LIKE ?",signal])    
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @signal_strengths.to_xml(:dasherize => false) }
    end
  end
  
  # GET /signal_strengths/:connection/1
  # GET /signal_strengths/:connection/1.xml
  def show
    SignalStrength.switch_data(params[:connection], "daily")
    #@signal_strengths = SignalStrength.find(params[:id])
    #@signal_strengths = SignalStrength.find(:all, :origin=>'94531', :within=>10)
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @signal_strengths.to_xml(:dasherize => false) }
    end
  end
  
  # GET /signal_strengths/:connection/2009/1/1
  # GET /signal_strengths/:connection/2009/1/1.xml
  def find_by_date
    SignalStrength.switch_data(params[:connection], "daily")
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    #Default Parameters
    from_signal = params[:startsignal] ? params[:startsignal] : "0"
    to_signal = params[:endsignal] ? params[:endsignal] : "100"
    origin = (params[:lat] and params[:lng]) ? [params[:lat], params[:lng]] : (params[:origin]) ? params[:origin] : ['','']
    radius = params[:radius] ? params[:radius] : 0
    @signal_strengths = SignalStrength.find(:all, :origin=>origin, :within => radius, :conditions => ["day(server_date) =? and month(server_date) =? and year(server_date) =? and server_signal >=? and server_signal <=?", 
                                                          params[:day], params[:month], params[:year],from_signal, to_signal])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @signal_strengths.to_xml(:dasherize => false) }
    end
  end
  
  # GET /signal_strengths/:connection/daily/2009/1
  # GET /signal_strengths/:connection/daily/2009/1.xml
  # GET /signal_strengths/:connection/daily/2009/1.xls
  # GET /signal_strengths/:connection/daily/2009/1.csv
  # GET /signal_strengths/:connection/monthly/2009/1
  # GET /signal_strengths/:connection/monthly/2009/1.xml
  # GET /signal_strengths/:connection/monthly/2009/1.xls
  # GET /signal_strengths/:connection/monthly/2009/1.csv
  def find_by_month
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    signal = params[:signal] ? params[:signal] : "%"
    if params[:period] == "monthly"
      SignalStrength.switch_data(params[:connection], "monthly")
      @signal_strengths = SignalStrength.find(:all, :conditions => ["server_date =? and server_year =? and server_signal LIKE ?", 
                                                            params[:month],params[:year],signal])
    else
      SignalStrength.switch_data(params[:connection], "daily")
      @signal_strengths = SignalStrength.find(:all, :conditions => ["month(server_date) =? and year(server_date) =? and server_signal LIKE ?", 
                                                            params[:month], params[:year],signal])
    end
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @signal_strengths.to_xml(:dasherize => false) }
      format.xls { send_data @signal_strengths.to_xls }
      format.csv { send_data @signal_strengths.to_csv }
    end
  end
end
