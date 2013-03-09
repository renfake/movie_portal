require 'nav_bar_filter'
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :current_nav_filter_for_site


  protected
    def current_nav_filter_for_site
      @current_main_nav = NavBarFilter.current_tab_for(controller_path)
    end
end
