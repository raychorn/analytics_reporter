class TransfersController < ApplicationController
  # GET /transfers
  # GET /transfers.xml
  def index
    @transfers = Transfer.find :all    
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @transfers.to_xml(:dasherize => false) }
    end
  end
  
  # GET /transfers/1
  # GET /transfers/1.xml
  def show
    @transfers = Transfer.find(params[:id])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @transfers.to_xml(:dasherize => false) }
    end
  end
  
  # GET /transfers/2009/1/1
  # GET /transfers/2009/1/1.xml
  def find_by_date
    date = params[:year] + "-" + params[:month] + "-" + params[:day]
    @transfers = Transfer.find(:all, :conditions => ["server_date =?", date])
    respond_to do |format|
      format.html #show.html.erb
      format.xml { render :xml => @transfers.to_xml(:dasherize => false) }
    end
  end
end
