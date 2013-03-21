require 'nav_bar_filter'
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :current_nav_filter_for_site


  def store_location
    session[:return_to] = request.referer if request.get? and controller_name != "user_sessions" and controller_name != "sessions"
  end

  def back_or_default_path(default)
    session[:return_to] || default
  end

  def redirect_back_or_default(default)
    redirect_to back_or_default_path(default)
  end

  protected
    def current_nav_filter_for_site
      @current_main_nav = NavBarFilter.current_tab_for(controller_path)
    end
end
