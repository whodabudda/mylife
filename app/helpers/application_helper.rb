module ApplicationHelper

	def show_params
		@return_str = "<p> <strong> List of Parameters </strong></p>"
		params.each do |key, value| 
		  @return_str.concat ("<p> key:" + key + " value:" + value + "</p>")
		end
		@return_str.concat "<p> <strong> List of Session attributes </strong></p>"
		
	    @return_str.concat debug (session)
	    @return_str.concat "current user is: " + current_duser.to_s
	    #or session.inspect
		

		return raw @return_str
    end
end
