class PlaybacksController < ApplicationController
  # GET /playbacks
  # GET /playbacks.xml
  def index
    @playbacks = Playback.find :all    
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @playbacks.to_xml(:dasherize => false) }
    end
  end
  
  # GET /playbacks/1
  # GET /playbacks/1.xml
  def show
    @playbacks = Playback.find(params[:id])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @playbacks.to_xml(:dasherize => false) }
    end
  end
  
  # GET /playbacks/2009/1/1
  # GET /playbacks/2009/1/1.xml
  def find_by_date
    date = params[:year] + "-" + params[:month] + "-" + params[:day]
    @playbacks = Playback.find(:all, :conditions => ["server_date =?", date])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @playbacks.to_xml(:dasherize => false) }
    end
  end
end
