require 'fpdf'
require 'table'
class FPDF
  include Fpdf::Table
end

class EventsController < ApplicationController
  
  before_filter :login_required
  
  #GET events
  #GET events.xml
  #GET events.xls
  #GET events.csv
  #GET events/daily
  #GET events/daily.xml
  #GET events/daily.xls
  #GET events/daily.csv
  #GET events/monthly
  #GET events/monthly.xml
  #GET events/monthly.xls
  #GET events/monthly.csv
  def index
    if params[:period]
      Event.switch_data(params[:connection], params[:period])
    else
      Event.switch_data(params[:connection], "daily")
    end
    respond_to do |format|
      format.html #index.html.erb
      format.mobile { 
                      @current_time = Time.new
                      @show_time = @current_time.utc.strftime("%Y/%m/%d")
                      @events = Event.find(:all, :conditions => ["day(server_date) =? and month(server_date) =? and year(server_date) =?", @current_time.utc.strftime("%d"), @current_time.utc.strftime("%m"), @current_time.utc.strftime("%Y")])
                      @events_1 = Event.find(:all, :conditions => ["day(server_date) =? and month(server_date) =? and year(server_date) =? and server_event =?", (@current_time-86400).utc.strftime("%d"), (@current_time-86400).utc.strftime("%m"), (@current_time-86400).utc.strftime("%Y"),1])
                      @events_2 = Event.find(:all, :conditions => ["day(server_date) =? and month(server_date) =? and year(server_date) =? and server_event =?", (@current_time-86400*2).utc.strftime("%d"), (@current_time-86400*2).utc.strftime("%m"), (@current_time-86400*2).utc.strftime("%Y"),1])
                      render :layout => 'mobile' 
                    }
      format.xml { 
                   @events = Event.find :all 
                   render :xml => @events.to_xml(:root => 'records', :children => 'record', :dasherize => false) 
                 }
      format.xls { 
                   @events = Event.find :all 
                   send_data @events.to_xls 
                 }
      format.csv { 
                   @events = Event.find :all 
                   send_data @events.to_csv 
                 }
    end
  end
  
  #GET events/1
  #GET events/1.xml
  #GET events/daily/1
  #GET events/daily/1.xml
  #GET events/daily/1.csv
  #GET events/monthly/1
  #GET events/monthly/1.xml
  #GET events/monthly/1.csv
  def show
    if params[:period]
      Event.switch_data(params[:connection], params[:period])
    else
      Event.switch_data(params[:connection], "daily")
    end
    from_date = params[:startdate] ? params[:startdate] : 6.months.ago.utc.strftime("%Y-%m-%d")
    to_date = params[:enddate] ? params[:enddate] : Time.now.utc.strftime("%Y-%m-%d")
    @events = Event.find(:all, :select => "server_date, server_event,SUM(server_count) AS view_count", :group => "server_date", :conditions => ["server_date >= ? and server_date <= ? and server_event =?",
                                                          from_date,to_date,params[:id]]) 
    #@events = Event.find(:all, :group => "server_date", :conditions => ["server_event =?", params[:id]])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { 
        if params[:period] == "monthly"
          render :xml => @events.to_xml(:root => 'records', :children => 'record', :dasherize => false, :skip_types => true) 
        else
          render :xml => @events.to_xml(:root => 'records', :children => 'record', :dasherize => false, :skip_types => false) 
        end
      }
    end
  end  
  
  # GET /events/2009/1/1
  # GET /events/2009/1/1.xml
  # GET /events/2009/1/1.xls
  # GET /events/2009/1/1.csv
  def find_by_date
    Event.switch_data(params[:connection], "daily")
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    @events = Event.find(:all, :conditions => ["day(server_date) =? and month(server_date) =? and year(server_date) =?", params[:day], params[:month], params[:year]])
    respond_to do |format|
      format.html #show.html.erb
      format.mobile {
                      @current_time = Time.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
                      @show_time = params[:year] + "/" + params[:month] + "/" + params[:day]
                      @events_1 = Event.find(:all, :conditions => ["day(server_date) =? and month(server_date) =? and year(server_date) =? and server_event =?", (@current_time-86400).utc.strftime("%d"), (@current_time-86400).utc.strftime("%m"), (@current_time-86400).utc.strftime("%Y"),1])
                      @events_2 = Event.find(:all, :conditions => ["day(server_date) =? and month(server_date) =? and year(server_date) =? and server_event =?", (@current_time-86400*2).utc.strftime("%d"), (@current_time-86400*2).utc.strftime("%m"), (@current_time-86400*2).utc.strftime("%Y"),1])
                      render :template => 'events/index', :layout => 'mobile'
                    }
      format.xml { render :xml => @events.to_xml(:root => 'records', :children => 'record', :dasherize => false, :skip_types => false) }
      format.xls { send_data @events.to_xls }
      format.csv { send_data @events.to_csv }
    end
  end
  
  # GET /events/daily/2009/1
  # GET /events/daily/2009/1.xml
  # GET /events/daily/2009/1.xls
  # GET /events/daily/2009/1.csv
  # GET /events/daily/2009/1.pdf
  # GET /events/monthly/2009/1
  # GET /events/monthly/2009/1.xml
  # GET /events/monthly/2009/1.xls
  # GET /events/monthly/2009/1.csv
  # GET /events/monthly/2009/1.pdf
  def find_by_month
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    if params[:period] == "monthly"
      Event.switch_data(params[:connection], "monthly")
      Event.switch_table("monthly")
      @events = Event.find(:all, :conditions => ["server_date =? and server_year =?", params[:month],params[:year]])
    elsif params[:period] == "weekly"
      Event.switch_data(params[:connection], "weekly")
      @events = Event.find(:all, :conditions => ["server_date =? and server_year =?", params[:month],params[:year]])
    else
      Event.switch_data(params[:connection], "daily")
      @events = Event.find(:all, :conditions => ["month(server_date) =? and year(server_date) =?", params[:month], params[:year]])
    end
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @events.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
      format.xls { send_data @events.to_xls }
      format.csv { send_data @events.to_csv }
      if params[:period] == "monthly"
        format.pdf { send_data gen_pdf(params[:period],params[:year],params[:month]), :filename => "V_CAST_Media_Manager_Report_(#{Date::MONTHNAMES[params[:month].to_i]}-#{params[:year]}).pdf", :type => "application/pdf" }
      elsif
        format.pdf { send_data gen_pdf(params[:period],params[:year],params[:month]), :filename => "V_CAST_Media_Manager_Report_(Week#{params[:month]}of52-#{params[:year]}).pdf", :type => "application/pdf" }
      end
    end
  end
  
  # GET /events/daily/2009
  # GET /events/daily/2009.xml
  # GET /events/daily/2009.xls
  # GET /events/daily/2009.csv
  # GET /events/monthly/2009
  # GET /events/monthly/2009.xml
  # GET /events/monthly/2009.xls
  # GET /events/monthly/2009.csv
  def find_by_year
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    if params[:period] == "monthly"
      Event.switch_data(params[:connection], "monthly")
      @events = Event.find(:all, :conditions => ["server_year =?", params[:year]])
    elsif params[:period] == "weekly"
      Event.switch_data(params[:connection], "weekly")
      @events = Event.find(:all, :conditions => ["server_date =? and server_year =?", params[:month],params[:year]])
    else
      Event.switch_data(params[:connection], "daily")
      @events = Event.find(:all, :conditions => ["year(server_date) =?", params[:year]])
    end
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @events.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
      format.xls { send_data @events.to_xls }
      format.csv { send_data @events.to_csv }
    end
  end
  
  def pdf
    send_data gen_pdf(params[:period],params[:year],params[:month]), :filename => "Quicklink_Analytics_Report_(#{Date::MONTHNAMES[params[:month].to_i]}-#{params[:year]}).pdf", :type => "application/pdf"
  end

 private
  def gen_pdf(period,year,month)
    #Find the Unique Number of Users for a Month
    if period == "monthly"
      Event.switch_table("monthly")
    elsif period == "weekly"
      Event.switch_table("weekly")
    else
      Event.switch_table("daily")
    end
    @users = Event.find(:first, :conditions => ["server_date =? and server_year =? and server_event =?", month,year,'1'])
    @ids = Id.count(:conditions => ["month(server_date) =? and year(server_date) =?", month, year])
    
    #Find the Unique Number of Users for each day of the Month + the Sum of Events Triggered
    Event.switch_table("daily")
    if period == "monthly"
      values = Event.sum(:server_count, :group => :server_date, :conditions => ["month(server_date) =? and year(server_date) =?", month, year])
    elsif period == "weekly"
      values = Event.sum(:server_count, :group => :server_date, :conditions => ["week(server_date) =? and year(server_date) =?", month, year])
    else
      values = Event.sum(:server_count, :group => :server_date, :conditions => ["month(server_date) =? and year(server_date) =?", month, year])
    end

    d = Date.today
    columns = [
      {:title => 'Date', :width => 30},  
      {:title => '# of active users', :aligment => 'R', :width => 40},
      {:title => '# of usage events', :aligment => 'R', :width => 40},
      {:title => '# of new users', :aligment => 'R', :width => 40},
      {:title => '% of new users', :aligment => 'R', :width => 20}
    ]
    
    pdf=FPDF.new
    pdf.AddPage
    pdf.SetFont('Arial')
    pdf.SetFontSize(10)

    pdf.Image(RAILS_ROOT + '/app/flex/com/mxplay/analytics/assets/smsi_logo.jpg',10,8,35,0,'JPG')

    pdf.Cell(0,6, "SmithMicro Software", 0,1,'R')
    pdf.Cell(0,6, "51 Columbia",0,1,'R')
    pdf.Cell(0,6, "Aliso Viejo, CA 92656",0,0,'R')

    pdf.Ln
    
    #Set font
    pdf.SetFont('Arial','BU',16);
    pdf.Cell(80);
    pdf.Cell(20,10,'V CAST Media Manager User Report',0,1,'C');

    pdf.Ln
    
    pdf.SetFont('Arial','B',12);
    if period == "monthly"
      pdf.Write(5, "Reporting Period: #{Date::MONTHNAMES[month.to_i]}, #{year}")
    elsif period == "weekly"
      pdf.Write(5, "Reporting Period: Week #{month} of 52, #{year}")
    else
      pdf.Write(5, "Reporting Period: #{Date::MONTHNAMES[month.to_i]}, #{year}")
    end
    pdf.Ln
    pdf.Ln
    
    pdf.SetFont('Arial','',12);
    pdf.Write(5, "Total Active Users: #{@users.server_count}")
    pdf.Ln
    pdf.Write(5, "Total New Users: #{@ids}")
    pdf.Ln
    pdf.Ln
    
    i=0
    data = []
    values.each do |server_date, sum|
      print server_date + ","
      count = Event.find(:first, :conditions => ["server_date =? and server_event =?", server_date, 1])
      if count != nil
	      new_users = Id.count(:conditions => ["server_date =?", server_date])
	      percentage = (100-(((((count.server_count).to_i)-(new_users.to_i))/((count.server_count).to_f))*100)).round
	      #pdf.Write(5, "#{server_date}, #{count.server_count}, #{sum} | ")
	      data << [server_date.to_s, count.server_count.to_s, sum.to_s, new_users.to_s, percentage.to_s + "%"]
      else
	      data << [server_date.to_s, "0", "0", "0", "0" + "%"]
	  end    	  
      i=i+1
    end
    
    pdf.Write(5, "Daily active usage:")
    pdf.Ln
    pdf.Ln
    pdf.table(data, columns)
    
    pdf.Ln
    pdf.Cell(0,6, "SmithMicro", 0,1,'L',0,'http://www.smithmicro.com/')
    pdf.Output
  end
  
end
