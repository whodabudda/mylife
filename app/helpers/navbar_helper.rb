module NavbarHelper
	def session_message
		@log_str = ""
		
		if duser_signed_in?
		  @log_str = 'Welcome '.concat current_duser.username.to_str 
		 else
		  @log_str = link_to('Please Sign-Up or sign-In', new_duser_session_path, class: "navbar-link")
		end
#		return raw '<p class="navbar-text navbar-right">' + @log_str + '</p>'
		return  @log_str 
    end
end