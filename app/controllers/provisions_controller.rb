class ProvisionsController < ApplicationController
  # GET /provisions/:handswap
  # GET /provisions/:handswap.xml
  def index
    if params[:period]
      Provision.switch_data(params[:connection], params[:period])
    else
      Provision.switch_data(params[:connection], "daily")
    end
    server_handset = params[:handset] ? params[:handset] : "%"
    server_release = params[:release] ? params[:release] : "%"
    server_version = params[:version] ? params[:version] : "%"
    from_date = params[:startdate] ? params[:startdate] : 1.months.ago.utc.strftime("%Y-%m-%d")
    to_date = params[:enddate] ? params[:enddate] : Time.now.utc.strftime("%Y-%m-%d")
    @provisions = Provision.find(:all, :select => "server_date ,SUM(server_count) AS view_count", :group => "server_date", :conditions => ["server_date >= ? and server_date <= ? and server_handset LIKE ? and server_release LIKE ? and server_version LIKE ?",
                                                          from_date,to_date,server_handset,server_release,server_version]) 
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @provisions.to_xml(:root => 'records', :children => 'record', :dasherize => false, :skip_types => true) }
    end
  end
  
  # GET /provisions/:handswap/1
  # GET /provisions/:handswap/1.xml
  def show
    Provision.switch_data(params[:handswap], "daily")
    @provisions = Provision.find(:all, :group => "server_date", :conditions => ["server_deviceid =?", params[:id]])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @provisions.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
    end
  end
end
