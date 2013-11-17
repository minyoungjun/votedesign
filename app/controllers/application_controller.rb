class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def is_logged_in
    if session[:login] != true
      redirect_to :controller => 'vote', :action => 'login'
    end
  end

  def is_admin
    if session[:admin_id].nil? 
      redirect_to :controller => 'admin', :action => 'login'
    else
      @admin = Admin.where(:id => session[:admin_id]).first
    end
  end

private
  def record action_type, actor, location

    r = Recorder.new
    r.action_type, r.actor, r.location = 
              action_type, actor, location
    r.save

  end
end
