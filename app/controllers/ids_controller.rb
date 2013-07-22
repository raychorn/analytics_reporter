class IdsController < ApplicationController
  # GET /ids
  # GET /ids.xml
  def index
    @ids = Id.find :first    
    respond_to do |format|
      format.html #index.html.erb
      format.xml { render :xml => @ids.to_xml(:dasherize => false) }
      format.csv { send_data @ids.to_csv }
    end
  end
end
