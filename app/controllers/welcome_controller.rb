class WelcomeController < ApplicationController
  #before_action :authenticate_duser!
  def greeting
  	if duser_signed_in?
  	 redirect_to user_session_home_path
#       redirect_to user_session_chart_path, format: "js", turbolinks: false
    end
  end
  def about
  end
  def doc
  end
  def home
  end

end
