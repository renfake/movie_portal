class NavBarFilter
  def self.current_tab_for controller_path, nav_level = nil
    if controller_path =~ /^admin\/.*$/
      CONTROLLER_TAB_MAP[:admin][nav_level][controller_path]
    else
      CONTROLLER_TAB_MAP[:public][controller_path]
    end
  end


  CONTROLLER_TAB_MAP = {
      :admin => {
          :main_nav => {

          }
      },

      :public => {
          'site'   => 'main-dashboard',
          'movies' => 'main-movies'
      }

  }
end