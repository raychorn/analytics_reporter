class VttandroidsummariesController < ApplicationController
  before_filter :login_required
  
  # GET /vttandroidsummary/:Vttandroidsummary
  # GET /vttandroidsummary/:Vttandroidsummary.xml
  def index
    if params[:period]
      Vttandroidsummary.switch_data(params[:connection], params[:period])
    else
      Vttandroidsummary.switch_data(params[:connection], "daily")
    end
    from_date = params[:startdate] ? params[:startdate] : '%'#1.months.ago.utc.strftime("%Y-%m-%d")
    to_date = params[:enddate] ? params[:enddate] : Time.now.utc.strftime("%Y-%m-%d")
    
    select_params = { 
    	"record_date" => "record_date", 
    	"total_sub_cnt" => "total_sub_cnt" ,
    	"hs_upgraded_to_vtt_cnt" => "hs_upgraded_to_vtt_cnt",
    	"percent_hs_upgrade" => "percent_hs_upgrade",
    	"free_trial_user_cnt" => "free_trial_user_cnt",
    	"percent_free_trial_opt_in" => "percent_free_trial_opt_in",
    	"free_trial_to_mrc_cnt" => "free_trial_to_mrc_cnt",
    	"percent_mrc_from_free_trial_user" => "percent_mrc_from_free_trial_user",
    	"mrc_user_cnt" => "mrc_user_cnt",
    	"percent_mrc_user_cnt" => "percent_mrc_user_cnt"
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
    if params[:server_date]
    	select_params[params[:server_date]] = "server_date"
    end
    
    @vttandroidsummary = Vttandroidsummary.find(:all, :select => "record_date AS #{select_params['record_date']},total_sub_cnt AS #{select_params['total_sub_cnt']},hs_upgraded_to_vtt_cnt AS #{select_params['hs_upgraded_to_vtt_cnt']},percent_hs_upgrade AS #{select_params['percent_hs_upgrade']},free_trial_user_cnt AS #{select_params['free_trial_user_cnt']},percent_free_trial_opt_in AS #{select_params['percent_free_trial_opt_in']},free_trial_to_mrc_cnt AS #{select_params['free_trial_to_mrc_cnt']},percent_mrc_from_free_trial_user AS #{select_params['percent_mrc_from_free_trial_user']},mrc_user_cnt AS #{select_params['mrc_user_cnt']},percent_mrc_user_cnt AS #{select_params['percent_mrc_user_cnt']}", :group => "record_date",:conditions => ["record_date >= ? and record_date <= ?",from_date,to_date])    
    
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @vttandroidsummary.to_xml(:root => 'records', :children => 'record', :dasherize => false, :skip_types => true) }
    end
  end
  
  # GET /vttandroidsummary/:Vttandroidsummary/1
  # GET /vttandroidsummary/:Vttandroidsummary/1.xml
  def show
    Vttandroidsummary.switch_data(params[:Vttandroidsummary], "daily")
    @vttandroidsummary = Vttandroidsummary.find(params[:id])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @vttandroidsummary.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
    end
  end
  
  # GET /vttandroidsummary/:Vttandroidsummary/2009/1/1
  # GET /vttandroidsummary/:Vttandroidsummary/2009/1/1.xml
  def find_by_date
    Vttandroidsummary.switch_data(params[:connection], "daily")
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    vpn = params[:vpn] ? params[:vpn] : "%"
    type = params[:type] ? params[:type] : "%"
    @vttandroidsummary = Vttandroidsummary.find(:all, :conditions => ["day(record_date) =? and month(record_date) =? and year(record_date) =?", 
                                                          params[:day], params[:month], params[:year]])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @vttandroidsummary.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
    end
  end
  
  # GET /vttandroidsummary/:Vttandroidsummary/daily/2009/1
  # GET /vttandroidsummary/:Vttandroidsummary/daily/2009/1.xml
  # GET /vttandroidsummary/:Vttandroidsummary/daily/2009/1.xls
  # GET /vttandroidsummary/:Vttandroidsummary/daily/2009/1.csv
  # GET /vttandroidsummary/:Vttandroidsummary/monthly/2009/1
  # GET /vttandroidsummary/:Vttandroidsummary/monthly/2009/1.xml
  # GET /vttandroidsummary/:Vttandroidsummary/monthly/2009/1.xls
  # GET /vttandroidsummary/:Vttandroidsummary/monthly/2009/1.csv
  def find_by_month
    #date = params[:year] + "-" + params[:month] + "-" + params[:day]
    vpn = params[:vpn] ? params[:vpn] : "%"
    type = params[:type] ? params[:type] : "%"
    if params[:period] == "monthly"
      Vttandroidsummary.switch_data(params[:connection], "monthly")
      @vttandroidsummary = Vttandroidsummary.find(:all, :conditions => ["server_date =? and server_year =? and server_vpn LIKE ? and server_type LIKE ?", 
                                                            params[:month],params[:year],vpn,type])
    else
      Vttandroidsummary.switch_data(params[:connection], "daily")
      @vttandroidsummary = Vttandroidsummary.find(:all, :conditions => ["month(server_date) =? and year(server_date) =? and server_vpn LIKE ? and server_type LIKE ?", 
                                                            params[:month], params[:year],vpn,type])
    end
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @vttandroidsummary.to_xml(:root => 'records', :children => 'record', :dasherize => false) }
      format.xls { send_data @vttandroidsummary.to_xls }
      format.csv { send_data @vttandroidsummary.to_csv }
    end
  end
end
