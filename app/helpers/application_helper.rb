module ApplicationHelper

	def show_params
		@return_str = "<p> <strong> List of Parameters </strong></p>"
		params.each do |key, value| 
		  @return_str.concat ("<p> key:" + key.to_s + " value:" + value.to_s + "</p>")
		end
		@return_str.concat "<p> <strong> List of Session attributes </strong></p>"
		
	    @return_str.concat debug (session)
	    @return_str.concat "current user is: " + current_duser.to_s
	    #or session.inspect
		

		return raw @return_str
    end
    def comment
    end

    def glyph(*names)
    content_tag :i, nil, class: names.map{|name| "glyhpicon glyphicon-#{name.to_s.gsub('_','-')}" }
  end
end
