# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  has_mobile_fu
  include AuthenticatedSystem
  include GeoipSystem
  
  layout :template
  
  def template
      # return the layout to be used
      if is_mobile_device?
        return 'mobile'
      else
        return 'standard'
      end
  end
  
  def access_denied
    alias new_session_path login_path
    respond_to do |format|
      format.html do
        store_location
        redirect_to new_session_path
      end
      format.mobile do
        store_location
        redirect_to new_session_path
      end
      format.any do
        request_http_basic_authentication 'Web Password'
      end
    end
  end

  
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
