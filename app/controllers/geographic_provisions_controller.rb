class GeographicProvisionsController < ApplicationController
  # GET /geographicprovisions/vvm/daily.xml
  def index
    if params[:period]
      GeographicProvision.switch_data(params[:connection], params[:period])
    else
      GeographicProvision.switch_data(params[:connection], "daily")
    end
    server_handset = params[:handset] ? params[:handset] : "HERO200-ANDROID"
    server_release = params[:release] ? params[:release] : "%"
    server_version = params[:version] ? params[:version] : "%"
    #from_date = params[:startdate] ? params[:startdate] : 1.months.ago.utc.strftime("%Y-%m-%d")
    from_date = params[:startdate] ? params[:startdate] : 1.days.ago.utc.strftime("%Y-%m-%d")
    to_date = params[:enddate] ? params[:enddate] : Time.now.utc.strftime("%Y-%m-%d")
    #@geographic_provisions = GeographicProvision.find(:all, :select => "server_date ,SUM(server_count) AS view_count", :group => "server_date", :conditions => ["server_date >= ? and server_date <= ? and server_handset LIKE ? and server_release LIKE ? and server_version LIKE ?",
    #                                                      from_date,to_date,server_handset,server_release,server_version]) 
    @geographic_provisions = GeographicProvision.find_by_sql(["select g.handset, SUM(g.handset_count) AS count, a.area_code, a.city, a.location as state, a.country
                                                              from geographic_provisions g, area_codes a
                                                              where g.area_code = a.area_code
                                                              and g.service_date >= ? and g.service_date <= ?
                                                              and g.handset = ?
                                                              group by g.handset, a.area_code", from_date, to_date, server_handset])
    
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @geographic_provisions.to_xml(:root => 'records', :children => 'record', :dasherize => false, :skip_types => true) }
    end
  end
  
  def handsets
    if params[:period]
      Swap.switch_data(params[:connection], params[:period])
    else
      Swap.switch_data(params[:connection], "daily")
    end
    handset_type = params[:id] ? params[:id] : "all"   
    from_date = params[:startdate] ? params[:startdate] : 1.days.ago.utc.strftime("%Y-%m-%d")
    to_date = params[:enddate] ? params[:enddate] : Time.now.utc.strftime("%Y-%m-%d")
    
    
    if(handset_type == "all")
      #@handset_type = GeographicProvision.find(:all, :select => "handset", :group => "handset", :order => "handset ASC", :conditions => ["server_date >= ? and server_date <= ?", from_date,to_date])
      @handset_type = GeographicProvision.find_by_sql(["select g.handset
                                                              from geographic_provisions g, area_codes a
                                                              where g.area_code = a.area_code
                                                              and g.service_date >= ? and g.service_date <= ?
                                                              group by g.handset", from_date, to_date])
    end
        
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @handset_type.to_xml(:root => 'records', :children => 'record', :dasherize => false, :skip_types => true) }
    end
  end
  
end
