class ZoomsController < ApplicationController
  # GET /zooms
  # GET /zooms.xml
  def index
    @zooms = Zoom.find :all    
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @zooms.to_xml(:dasherize => false) }
    end
  end
  
  # GET /zooms/1
  # GET /zooms/1.xml
  def show
    @zooms = Zoom.find(params[:id])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @zooms.to_xml(:dasherize => false) }
    end
  end
  
  # GET /zooms/2009/1/1
  # GET /zooms/2009/1/1.xml
  def find_by_date
    date = params[:year] + "-" + params[:month] + "-" + params[:day]
    @zooms = Zoom.find(:all, :conditions => ["server_date =?", date])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @zooms.to_xml(:dasherize => false) }
    end
  end
end
