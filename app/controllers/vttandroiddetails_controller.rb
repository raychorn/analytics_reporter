class VttandroiddetailsController < ApplicationController 
  before_filter :login_required
  
  # GET /vttandroiddetails/:Vttandroiddetail
  # GET /vttandroiddetails/:Vttandroiddetail.xml
  def index
    if params[:period]
      Vttandroiddetail.switch_data(params[:connection], params[:period])
    else
      Vttandroiddetail.switch_data(params[:connection], "daily")
    end
    from_date = params[:startdate] ? params[:startdate] : '%'#1.months.ago.utc.strftime("%Y-%m-%d")
    to_date = params[:enddate] ? params[:enddate] : Time.now.utc.strftime("%Y-%m-%d")
    vtt_hs_type = params[:vtt_hs_type] ? params[:vtt_hs_type] : "%"
    
    #Select Parameters
    select_params = { 
    	"record_date" => "record_date", 
    	"vtt_hs_type" => "vtt_hs_type", 
    	"total_sub_cnt" => "total_sub_cnt" ,
    	"hs_upgraded_to_vtt_cnt" => "hs_upgraded_to_vtt_cnt",
    	"free_trial_user_cnt" => "free_trial_user_cnt",
    	"free_trial_to_mrc_cnt" => "free_trial_to_mrc_cnt",
    	"mrc_user_cnt" => "mrc_user_cnt",
    	"expired_ft_cnt" => "expired_ft_cnt"
    }
    if params[:view_count]
    	select_params[params[:view_count]] = "view_count"
    end
    if params[:region]
    	select_params[params[:region]] = "region"
    end
    if params[:value]
    	select_params[params[:value]] = "value"
    end
    if params[:server_date]
    	select_params[params[:server_date]] = "server_date"
    end
    
    @vttandroiddetails = Vttandroiddetail.find(:all, :select => "record_date AS #{select_params['record_date']},vtt_hs_type AS #{select_params['vtt_hs_type']},total_sub_cnt AS #{select_params['total_sub_cnt']},hs_upgraded_to_vtt_cnt AS #{select_params['hs_upgraded_to_vtt_cnt']},free_trial_user_cnt AS #{select_params['free_trial_user_cnt']},free_trial_to_mrc_cnt AS #{select_params['free_trial_to_mrc_cnt']},mrc_user_cnt AS #{select_params['mrc_user_cnt']},expired_ft_cnt AS #{select_params['expired_ft_cnt']}", :group => "record_date,vtt_hs_type",:conditions => ["record_date >= ? and record_date <= ? and vtt_hs_type LIKE ?",from_date,to_date,vtt_hs_type])    
    #@vttandroiddetails = Vttandroiddetail.find(:all, :select => "record_date AS #{select_params['record_date']},vtt_hs_type AS #{select_params['vtt_hs_type']},total_sub_cnt AS #{select_params['total_sub_cnt']},hs_upgraded_to_vtt_cnt AS #{select_params['hs_upgraded_to_vtt_cnt']},free_trial_user_cnt AS #{select_params['free_trial_user_cnt']},free_trial_to_mrc_cnt AS #{select_params['free_trial_to_mrc_cnt']},mrc_user_cnt AS #{select_params['mrc_user_cnt']},expired_ft_cnt AS #{select_params['expired_ft_cnt']}", :group => "record_date,vtt_hs_type",:conditions => ["record_date >= ? and record_date <= ? and vtt_hs_type LIKE ?",from_date,to_date,vtt_hs_type])        
    
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @vttandroiddetails.to_xml(:root => 'records', :children => 'record', :dasherize => false, :skip_types => true) }
    end
  end
  
  # GET /vttandroiddetails/:Vttandroiddetail/1
  # GET /vttandroiddetails/:Vttandroiddetail/1.xml
  def show
    Vttandroiddetail.switch_data(params[:Vttandroiddetail], "daily")
    @vttandroiddetails = Vttandroiddetail.find(params[:id])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @vttandroiddetails.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
    end
  end
  
  # GET /vttandroiddetails/:Vttandroiddetail/2009/1/1
  # GET /vttandroiddetails/:Vttandroiddetail/2009/1/1.xml
  def find_by_date
    Vttandroiddetail.switch_data(params[:connection], "daily")
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    vpn = params[:vpn] ? params[:vpn] : "%"
    type = params[:type] ? params[:type] : "%"
    @vttandroiddetails = Vttandroiddetail.find(:all, :conditions => ["day(record_date) =? and month(record_date) =? and year(record_date) =?", 
                                                          params[:day], params[:month], params[:year]])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @vttandroiddetails.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
    end
  end
  
  # GET /vttandroiddetails/:Vttandroiddetail/daily/2009/1
  # GET /vttandroiddetails/:Vttandroiddetail/daily/2009/1.xml
  # GET /vttandroiddetails/:Vttandroiddetail/daily/2009/1.xls
  # GET /vttandroiddetails/:Vttandroiddetail/daily/2009/1.csv
  # GET /vttandroiddetails/:Vttandroiddetail/monthly/2009/1
  # GET /vttandroiddetails/:Vttandroiddetail/monthly/2009/1.xml
  # GET /vttandroiddetails/:Vttandroiddetail/monthly/2009/1.xls
  # GET /vttandroiddetails/:Vttandroiddetail/monthly/2009/1.csv
  def find_by_month
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    vpn = params[:vpn] ? params[:vpn] : "%"
    type = params[:type] ? params[:type] : "%"
    if params[:period] == "monthly"
      Vttandroiddetail.switch_data(params[:connection], "monthly")
      @vttandroiddetails = Vttandroiddetail.find(:all, :conditions => ["server_date =? and server_year =? and server_vpn LIKE ? and server_type LIKE ?", 
                                                            params[:month],params[:year],vpn,type])
    else
      Vttandroiddetail.switch_data(params[:connection], "daily")
      @vttandroiddetails = Vttandroiddetail.find(:all, :conditions => ["month(server_date) =? and year(server_date) =? and server_vpn LIKE ? and server_type LIKE ?", 
                                                            params[:month], params[:year],vpn,type])
    end
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @vttandroiddetails.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
      format.xls { send_data @vttandroiddetails.to_xls }
      format.csv { send_data @vttandroiddetails.to_csv }
    end
  end
end
