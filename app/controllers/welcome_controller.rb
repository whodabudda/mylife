class WelcomeController < ApplicationController
  #before_action :authenticate_duser!
  def greeting
  	if duser_signed_in?
  		render "home"
  	end
  end
  def about
  end
  def doc
  end
  def home
  end

end
