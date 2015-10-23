module ApplicationHelper

	def show_params
		@return_str = "<p> <strong> List of Parameters </strong></p>"
		params.each do |key, value| 
		  @return_str.concat ("<p> key:" + key + " value:" + value + "</p>")
		end
		return raw @return_str
    end
end
