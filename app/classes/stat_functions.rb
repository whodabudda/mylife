module StatFunctions
	#include ActiveSupport::Rescuable
	#rescue_from StandardError, with: :rserve_error

	#mattr_accessor :messages

	#@messages = {}
	#if the number of unique values is less than 6, consider the data categorical
 def fCategorical? (vect)
	return vect.map { |row| row[1]}.uniq.length < 6	 
 end
 def fUnary? (vect)
	return vect.map { |row| row[1]}.uniq.length == 1	 
 end
 #if the variable is binary or no more than 3 categories
 def fLogistical? (vect)
	return vect.map { |row| row[1]}.uniq.length.between? 2,3
 end
 def fLinear? (x,y)
 	#TODO run a cor.test() in R.  correlation coefficient near 1 or -1 is linear, near 0 is not.
 end
 #Perform a logistical regression test.
 #v_logit is the logit variable, either 0 or 1.  v_val is the value vector.  They must have the
 #same length. If the v_logit is zero for an associated v_val, it means the event associated with 
 #that value for the metric did not occur.  The glm logit test will give an odds ratio estimate of
 #the probability that the event would have occured for the range of values. 
 def logit_regression(v_val,v_logit)
   	Rails.logger.info("#{self.class.name}:#{__method__} -- logitsl are #{v_logit} ")
   	Rails.logger.info("#{self.class.name}:#{__method__} -- values are #{v_val} ")
 	if (v_logit.length - v_val.length) != 0
    	add_return_message('logit regression',"unable to perform test. Vectors not of equal length.")
    	return false
    end

    #assign the ruby vectors to R vectors
    @conn.assign "v_val",v_val
	@conn.assign "v_logit",v_logit
	#create a dataframe from the vectors, giving them names of value and fctor
	@conn.eval ("df <- data.frame( value = v_val, fctor = v_logit)") 


	#create the model usiing glm (generalized linear model)
	@conn.eval("model <- glm( fctor ~ value, data = df, family = binomial( link='logit'))")

	#extract the p value from the model
	pv = @conn.eval("pv <- round(coef(summary(model))['value','Pr(>|z|)'], 3) ").to_ruby

   	Rails.logger.info("#{self.class.name}:#{__method__} -- p_value is #{pv} ")
   	@conn.eval("df$predicted_prob <- predict(model, type = 'response')")
	#get the prediction values so we can return them in case we decide to show the chart through highcharts
	#y_prob = @conn.eval("y_prob").to_ruby

	#create the plot.  The return value is an R object, usually written to an output device, R's 'dev()', but in this case probably goes to a bit bucket since we don't have a display device.
#	@conn.eval("ggplot(df, aes(x = value, y = predict(model,type='response'))) + geom_point() + geom_smooth(method = 'glm', method.args = list(family = 'binomial'), se = FALSE) + labs(title = 'Logit Plot of Logistic Regression Model', x = 'value', y = 'Event') + theme_minimal(),+ annotate('text', x = median(df.value), y = max(df$predicted_prob), label = paste('p-value =', round(coef(summary(model))['value','Pr(>|z|)'], 3)))")
	@conn.eval("library(ggplot2)")
	@conn.eval("ggplot(df, aes(x = value, y = predicted_prob)) + 
		geom_point() + 
		geom_smooth(method = 'glm', method.args = list(family = 'binomial'), se = FALSE) +
		labs(title = 'Logit Plot of Logistic Regression Model', x = 'value', y = 'Probability of Event') +
		theme_gray() +
		annotate('text', x = median(df$value), y = 1, label = paste('p-value =',pv)) +
		coord_cartesian(ylim = c(0, 1))
		")

	#create a temporary file name. The backticks make this a "system" call to the os
	#The 'strip' on the end removes a trailing \n in the output, an artifact of the system function
	#RServe doesn't have a problem writing to the /tmp directory, however Rails will not access
	#any file system outside its sandbox, so we have to put the file in public
	#TODO: check to see if we need a cron job to clean up public/tmp
	#tf = `mktemp #{Rails.root}/public/tmp/r-img-XXXXXX.jpeg`.strip
	tf = `mktemp #{Rails.root}/app/assets/images/tmp/r-img-XXXXXX.jpeg`.strip
	@conn.assign "tf",tf   #give the temp filename to R
	#save the image to the tempfile. width and height are in inches
	@conn.eval("ggsave(tf,height = 5, width = 5, device = 'jpg')")    

	#get the file name without the path. Rails will look in public for /tmp/tfname
	@chartImageFile = File.basename(tf)
	#return the path to the tempfile. Need the full path for later delete.
	return tf
 end

 def independent_observations(x,y)
	Rails.logger.info("#{self.class.name}:#{__method__} parms are x: #{x} and y: #{y}")

	@conn.eval("library(lmtest)")
	@conn.assign "vx",x
	@conn.assign "vy",y
  	@conn.eval ("df <- data.frame( x = vx, y = vy)")
	@conn.eval("model <- lm(vy ~ vx, data = df)")
	r = @conn.eval("dwtest(model)").to_ruby
	pv = r["p.value"]  
	dw = r["statistic"]
	#H0 is that the data is homoskedastic.   
	# if the pv is < .05, reject H0 and accept H1, that there is evidence to support the data as
	# being heteroskedastic.
	# This should be in line with the DW value.  If < 1.5, consider data to be negative heteroskedastic.
	# If > 2.5, consider data to be positive heteroskedastic.
	# However the p-value overrides the dw value.
	if pv < 0.05 
		rslt =  "Reject H0, there is evidence that the data could be heteroskedastic."  
	else
		rslt =  "Not enough evidence to reject H0. The data is homoskedastic."  
	end
   	add_return_message("Durbin-Watson","p-value is: #{pv}, DW value is  #{dw}.")
   	add_return_message("Durbin-Watson","#{rslt}")
	Rails.logger.info("#{self.class.name}:#{__method__} --#{"Durbin-Watson"} returned pvalue: #{pv}")
	return pv
 end
 def getResiduals(x,y)
	Rails.logger.info("#{self.class.name}:#{__method__} parms are x: #{x} and y: #{y}")
	@conn.assign "vx",x
	@conn.assign "vy",y
	@conn.eval("model <- lm(y ~ x, data = data.frame(x = vx,y = vy))")
	r = @conn.eval("residuals(lm(y ~ x, data = data.frame(x = vx,y = vy)))").to_ruby
 end

 def isNormalDist?(vect)
  pv = 0
  @conn.assign "v1",vect
  r = @conn.eval("shapiro.test(as.vector(v1))").to_ruby
  pv = r["p.value"]
  Rails.logger.info("#{self.class.name}:#{__method__} shapiro.test returned pvalue: #{pv}")

  add_return_message("shapiro.test","p-value was #{pv}")
  add_return_message("shapiro.test","A high p-value for the shapiro test (> .05) means the variance is probably normally distributed, a requirement for standard regression tests")

 end

 def isHomoSkedastic?(x,y)
  pv = 0
  @conn.eval("library(lmtest)")
  @conn.assign "vx",x
  @conn.assign "vy",y
  r = @conn.eval("bptest(lm(y ~ x, data = data.frame(x = vx,y = vy)))").to_ruby
  pv = r["p.value"]
  Rails.logger.info("#{self.class.name}:#{__method__} Breusch-Pagan returned pvalue: #{pv}")

  add_return_message("Breusch-Pagan","p-value was #{pv}")
  add_return_message("Breusch-Pagan","A high p-value for the Breusch-Pagan (> .05) means the variance is probably consistent, adding support that the regression test is valid")

 end


 #TODO: 1. Decide if we need to keep the wilcox test
 #      2. If we keep it, change it to be called from individual stat classes, and take a parameter 
 # 		containing  the data instead of extracting it from the dataset. I don't know at this point 
 #      if there is any use-case that needs to be done before calling checkAssumptions on each class.
 # The wilcox test may be redundent to logical regression.  Here we are testing to see if 2 samples
 # are the same, one sample with an event, and the other without, While logical regression calculates 
 # probabilities of an event happening based on a samples value.  Seems like these two tests could be
 # evaluating the same relationship between two variations on a sample, however logical regression returns
 # more information.
 def wilcox_test 
 	#indexes are 0:metric_id, 1:value, 2:occur_dttm
 	#create an array of arrays of 2 elements. rslt[0] is the value, and rslt[1] is
 	#a factor, acknowledging simply that an event happened in the time span, or not.
 	#this way we can create a dataframe suitable for a Mann-whitney (wilcox) test
 	#that compares the distribution of 2 sets of data, one for the dataset with no
 	#events, and one where an event happened.  A p-value of <.05 says reject the null
 	#hypothesis that they are equal, and accept the alternative that there is a 
 	#difference between the samples. The wilcox test can work with small numbers of
 	#data that are not normally distributed.
	@rslt = []
	events = []
	binding.pry

	
	ds.each do |rec| 
		if rec[0] == @review.metric_id    #if this  
			#remove all the events in the stack if they are not in the result.span window
			#datetime math returns the result in days.  Convert to hours by multiplying times 24
			events.delete_if {|row| if (((rec[2].to_datetime - row[2].to_datetime).to_i * 24) > @review.span) ; true end }
			if (events.length > 0 )
			  @rslt.push [rec[1],1]  #yes, the event was in our time frame for this metric
			else
			  @rslt.push [rec[1],0]  #no, the event didn't happen within the time frame for this metric
			end
		else
			events.push rec  #this is an event, so push it on the stack
		end
	end
 	Rails.logger.info("#{self.class.name}:#{__method__} -- data for wilcox.test is #{@rslt} ")
 	#
 	#now separate the 2 columns in rslt into 2 separate arrays, one to act as the value, the 
 	#other as the factor.  The wilcox test will compare two distributions.  Here those 
 	#distributions are composed of the rslt array, identified by the value of the factor.
 	d = []
	(0..(@rslt[0].length-1)).each  { |i|
       d[i] = @rslt.map{|row| row[i] } }

	(0..(d.length-1)).each  { |i| 
		w = "w" + i.to_s
	  @conn.assign w,d[i]
	}

  wf = @conn.eval ("wf <- data.frame( value = w0, fctor = w1)").to_ruby
  wp = @conn.eval("wilcox.test(wf$value ~ as.factor(wf$fctor))").to_ruby
  pv = wp["p.value"]
 	if pv < 0.05
    	add_return_message("wilcox.test","p-value is: #{pv}, There may be a correllation between the metric and the event.")
  else
    	add_return_message("wilcox.test","p-value is: #{pv},  It cannot be determined that the events affect the metric")
  end
  return pv
 end
 #if the data are not parametric, need to perform non-parametric test for distribution, in this case
 #a Mann-Whitney test, implemented in R as a 'wilcox.test'
 #This actually compares two distributions
 def perform_nonparametric_test (theTest)
 	case theTest
 	when "wilcox.test"
 		wilcox_test
 	else
   	  add_return_message(theTest,"#{theTest} - a nonparametric test, is not yet implemented")
   	end
 	return true
 end



 def remove_outliers (vect,typ)
 	Rails.logger.info("#{self.class.name}:#{__method__} -- vector is : #{vect}")
 	@conn.assign "v",vect
 	@conn.void_eval <<MYTAG
 	#the result of quantile will have index 1 = lower and 2 = higher quantile
 	rm <- quantile(v,probs=c(.25,.75))
 	#get the values that are considered either low or high outliers for both 
 	#independent and dependent variables  (metric and event)
 	cuts <- subset(v,(v > rm[2] + (IQR(v)* 1.5)) | (v < rm[1] - (IQR(v) * 1.5)))
 	#remove these values from their datasets.  For most independent datasets (events), there
 	#won't be any outliers
 	#m1 <- setdiff(m1,m_cuts)	Don't try to use setdiffs for this.  It strips duplicates.
 	v <- v[ ! v %in% cuts]
MYTAG
	vect = @conn.eval("v").to_ruby
 	cuts = @conn.eval("cuts").to_ruby
 	Rails.logger.info("#{self.class.name}:#{__method__} -- variable cuts is a: #{cuts.class}") unless cuts.nil?
 	add_return_message("outliers", "#{cuts} were removed for #{typ}") unless cuts.nil?

 	Rails.logger.info("#{self.class.name}:#{__method__} -- outliers: #{cuts} were removed for #{typ}") unless cuts.nil?

	#cuts could be nil, so make sure we return an empty array even if empty
	if cuts.nil?
		return []
	else
 		return cuts.class == Integer ? [cuts] : cuts
 	end
 end


 #@messages is a hash, and the value is an array.  If the key exists, push the message onto the array.
 #if the key does not exest, assign the array to the key as a new entry.
 def add_return_message (key, msg)
 	if @messages.has_key?(key.to_sym)
 		@messages[key.to_sym].push(msg)
	else
	 	@messages[key.to_sym] = [msg]
 	end
 end

 def rserve_error(e)
 	#puts "Error: #{e.message}"
   # flash[:notice] = "Unable to connect to the Rserve server"
   # add_return_message ("Rserve", "Something went wrong with the R server so we cannot show you any analysis.")
   # add_return_message ("Rserve", " Please contact support if this problem persists")
   # raise e
   #redirect_back(fallback_location: root_path)
 end
		
end
=begin        
        #
        #TODO  use the sharpiro-wilks test (in R shapiro.test(array)  )   to test for normality.
        #It returns 2 fields:   W and p-value.  W is a measure of how well the data fill a noremal 
        #distribution between zero and 1, with 1 being perfect match.  p-value is the confidence level
        #that it is a normal dist.  Compare it to .05.  If greater than .05, you be 95% confident 
        #that the data follows a normal dist.
        for example, with this data, it passes with p-value > .05

        > tt <- c(1, 1, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 4, 4, 4)
        > shapiro.test( tt)
            Shapiro-Wilk normality test

        data:  tt
        W = 0.95461, p-value = 0.1945

        However, with this data it does not:
        Shapiro-Wilk normality test
        data:  c(2, 4, 3, 1, 2, 2, 5, 4, 5, 4, 4, 5, 4, 8, 6, 6, 4, 7, 7, 4, 4, 9, 9, 5, 5, 3, 3, 4, 10, 5, 4, 4)
        W = 0.91812, p-value = 0.01849

        #
        #as of now, we'll take a swag at it.

 def isCategorical?(type)
        recs = @dataset.select{ |rec| rec.series_type == type}.map{|rec| rec.value }
        n_tot = recs.count.to_f
        n_uniq = recs.uniq.count 
        n_pct = ((n_tot - n_uniq)/n_tot) * 100

        if(n_tot > 50)  
            return n_pct > 90
        else
            return n_pct > 70
        end
 end
=end