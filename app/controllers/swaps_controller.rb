class SwapsController < ApplicationController
  # GET /swaps/:handswap
  # GET /swaps/:handswap.xml
  def index
    if params[:period]
      Swap.switch_data(params[:connection], params[:period])
    else
      Swap.switch_data(params[:connection], "daily")
    end
    from_handset = params[:from_handset] ? params[:from_handset] : "%"
    to_handset = params[:to_handset] ? params[:to_handset] : "%"
    from_date = params[:startdate] ? params[:startdate] : 1.months.ago.utc.strftime("%Y-%m-%d")
    to_date = params[:enddate] ? params[:enddate] : Time.now.utc.strftime("%Y-%m-%d")
    @swaps = Swap.find(:all, :select => "server_date ,SUM(cumm_count) AS view_count", :group => "server_date", :conditions => ["server_date >= ? and server_date <= ? and from_handset LIKE ? and to_handset LIKE ?",
                                                          from_date,to_date,from_handset,to_handset])
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @swaps.to_xml(:root => 'records', :children => 'record', :dasherize => false, :skip_types => true) }
    end
  end
  
  # GET /swaps/:handswap/1
  # GET /swaps/:handswap/1.xml
  def show
    Swap.switch_data(params[:handswap], "daily")
    @swaps = Swap.find(:all, :group => "server_date", :conditions => ["server_deviceid =?", params[:id]])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @swaps.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
    end
  end
  
  def to_handset
    if params[:period]
      Swap.switch_data(params[:connection], params[:period])
    else
      Swap.switch_data(params[:connection], "daily")
    end
    to_handset = params[:id]
    to_release = params[:to_release] ? params[:to_release] : "%"
    to_version = params[:to_version] ? params[:to_version] : "%"
    from_date = params[:startdate] ? params[:startdate] : 1.months.ago.utc.strftime("%Y-%m-%d")
    to_date = params[:enddate] ? params[:enddate] : Time.now.utc.strftime("%Y-%m-%d")
    #@swaps = Swap.find(:all, :select => "from_handset AS region,SUM(cumm_count) AS value", :group => "from_handset", :conditions => ["server_date >= ? and server_date <= ? and to_handset LIKE ? and to_version LIKE ? and to_release LIKE ?",
    #                                                      from_date,to_date,to_handset,to_version,to_release])
    
   #sql_cmd = "(select from_handset AS region, FORMAT(sum(cumm_count), 0) as value from daily_swaps where server_date >= ? and server_date <= ? and to_handset LIKE ? and to_version LIKE ? and to_release LIKE ? group by from_handset order by value desc limit 9 offset 0)"
   sql_cmd = "(select from_handset AS region, sum(cumm_count) as value from daily_swaps where server_date >= ? and server_date <= ? and to_handset LIKE ? and to_version LIKE ? and to_release LIKE ? group by from_handset order by value desc limit 9 offset 0)"
   sql_cmd = sql_cmd + "union (select 'Others' as region, (t.total - sum(d.value)) as value from "
   sql_cmd = sql_cmd + "(select from_handset AS region,SUM(cumm_count) AS value from daily_swaps where server_date >= ? and server_date <= ? and to_handset LIKE ? and to_version LIKE ? and to_release LIKE ? group by from_handset order by value desc limit 9 offset 0) d,"
   sql_cmd = sql_cmd + "(select SUM(cumm_count) AS total from daily_swaps where server_date >= ? and server_date <= ? and to_handset LIKE ? and to_version LIKE ? and to_release LIKE ?) t)"
   @swaps = Swap.find_by_sql([sql_cmd, from_date,to_date,to_handset,to_version,to_release, from_date,to_date,to_handset,to_version,to_release, from_date,to_date,to_handset,to_version,to_release])    
     
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @swaps.to_xml(:root => 'records', :children => 'record', :dasherize => false, :skip_types => true) }
    end
  end
  
  def handset_type
    if params[:period]
      Swap.switch_data(params[:connection], params[:period])
    else
      Swap.switch_data(params[:connection], "daily")
    end
    handset_type = params[:id] ? params[:id] : "from_handset_type"   
    from_date = params[:startdate] ? params[:startdate] : 3.months.ago.utc.strftime("%Y-%m-%d")
    to_date = params[:enddate] ? params[:enddate] : Time.now.utc.strftime("%Y-%m-%d")
    #@from_handset_type = Swap.find_by_sql("select from_handset from #{period}_swaps where ") 
    # for count.xml
    #from_handset = params[:from_handset] ? params[:from_handset] : "HERO200-ANDROID"  
    from_handset = params[:from_handset] ? params[:from_handset] : "HERO200-ANDROID"
    to_handset = params[:to_handset] ? params[:to_handset] : "HERO200-ANDROID"   
    
    #select * from swap where from_handset="handsetA" and to_handset+""
    
    #select distinct from_handset from swap
    #select distinct to_handset from swap
    #select server_date, sum(server_count) from swap where from_handset= ? and to_handset=? group by server_date
    
    #select distinct from_handset, to_handset, server_date, sum(server_count) from swap where .... 
    
    if(handset_type == "from_handset_type")
      @handset_type = Swap.find(:all, :select => "from_handset", :group => "from_handset", :order => "from_handset ASC", :conditions => ["server_date >= ? and server_date <= ?", from_date,to_date])
    elsif (handset_type == "to_handset_type")
      @handset_type = Swap.find(:all, :select => "to_handset", :group => "to_handset", :order => "to_handset ASC", :conditions => ["server_date >= ? and server_date <= ?", from_date,to_date])
    elsif (handset_type == "count")
      @handset_type = Swap.find(:all, :select => "server_date, SUM(cumm_count) as cumm_count", :group => "server_date", :conditions => ["server_date >= ? and server_date <= ? and from_handset LIKE ? and to_handset LIKE ?",
                                                          from_date,to_date,from_handset, to_handset])
    end
        
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @handset_type.to_xml(:root => 'records', :children => 'record', :dasherize => false, :skip_types => true) }
    end
  end
  
  #def handset_result(from_date, to_date)
  #  @from_handset = Swap.find(:all, :select => "from_handset", :group => "from_handset", :conditions => ["server_date >= ? and server_date <= ?", from_date,to_date])
  #  @to_handset = Swap.find(:all, :select => "to_handset", :group => "to_handset", :conditions => ["server_date >= ? and server_date <= ?", from_date,to_date])
  #  @swap = @from_handset + @to_handset
  #  return @swap
  #end

  def daily_count
    if params[:period]
      Swap.switch_data(params[:connection], params[:period])
    else
      Swap.switch_data(params[:connection], "daily")
    end
    from_handset = params[:id] ? params[:id] : "KYOCERA-SCP-2700"  
    to_handset = params[:id] ? params[:id] : "HERO200-ANDROID"   
    from_date = params[:startdate] ? params[:startdate] : 1.months.ago.utc.strftime("%Y-%m-%d")
    to_date = params[:enddate] ? params[:enddate] : Time.now.utc.strftime("%Y-%m-%d")
    
    @swaps = Swap.find(:all, :select => "server_date, SUM(cumm_count)", :group => "server_date", :conditions => ["server_date >= ? and server_date <= ? and from_handset LIKE ? and to_handset LIKE ?",
                                                          from_date,to_date,from_handset, to_handset]) 
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @swaps.to_xml(:root => 'records', :children => 'record', :dasherize => false, :skip_types => true) }
    end
  end
  # --------------------------------------------------------------------------------
end
