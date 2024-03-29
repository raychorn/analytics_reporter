# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  #include AuthenticatedSystem

  # GET /session/new
  # GET /session/new.xml
  # render new.rhtml
  def new
    respond_to do |format|
        format.html do
          render :layout => 'standard'
        end
        format.mobile do
          render :layout => 'mobile' 
        end
      end
  end

  # POST /session
  # POST /session.xml
  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      respond_to do |format|
        format.html do
          redirect_back_or_default('/')
          flash[:notice] = "Logged in succesfully"
        end
        format.mobile { redirect_to('/events.mobile') }
        format.xml { render :xml => self.current_user.to_xml(:dasherize => false) }
      end
    else
      respond_to do |format|
        format.html { render :action => 'new' }
        format.mobile { render :action => 'new', :format => 'mobile' }
        format.xml { render :text => "badlogin" }
      end
    end
  end

  # DELETE /session
  # DELETE /session.xml
  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
end
