
module StatAssumptions

	#the && operator must be at the end of the line if multiple lines
	def validData?
		! y_profile[:isInvalid] && 
		! x_profile[:isInvalid] 
	end
	def linear_regression?
		 y_profile[:isContinuous] 
	end
	def logistic_regression?
		y_profile[:isLogistical] &&
		x_profile[:isCategorical]
	end
	def independent_t_test?
		y_profile[:isContinuous] &&
		!x_profile[:isUnary]
	end
	def unary_regression?
		x_profile[:isUnary] && 
		y_profile[:isContinuous]
	end
	def paired_samples_t_test?
		y_profile[:isContinuous] &&
		 x_profile[:isBinary]
	end
end

