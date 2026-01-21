require 'rserve'
#base class for the stat inheritance hierarchy.  Provides the raw data for all stat functions.
class StatSample
	include ActiveSupport::Rescuable
	include StatFunctions
	#rescue_from StandardError, with: :rserve_error
	attr_accessor :ds, :messages, :x_profile, :y_profile
	attr_reader :metadata, :dataset, :conn, :assumptions,:x_values, :y_values,:x_occur_dttm, :y_occur_dttm,:chartImageFile

 def initialize (review,conn)
 	@review = review
 	@metadata = {}
  @messages = {}
  @x_profile = {}
  @y_profile = {}
  @x_values = []
  @y_values = []
  @x_occur_dttm = []
  @y_occur_dttm = []
  @ds = []
  #the each element in the assumptions array must be defined as a method.
  @assumptions = [:isContinuous?, :isCategorical?, :isLogistical? ,:isInvalid?,:isUnary?]
  #@conn MUST be closed when all the stat objects have done their work.  The only good way is
  #to enclose the connection in a begin/ensure/end block, which is done in the controller, and
  #handed to this object.
 	@conn = conn
  @chartImageFile = nil
 	set_stat_data
 end
 def runAssumptions
 		@assumptions.each do |ass|
 			self.public_send(ass)
 		end
    Rails.logger.info("#{self.class.name}:#{__method__} -- x_profile: #{@x_profile}, y_profile: #{@y_profile}")
 end
 def isInvalid?
  @y_profile[:isInvalid] =  y_values.uniq.length == 0
  @x_profile[:isInvalid] =  x_values.length == 0
 end
 #if the vector is not unary and less than 6 unique values, it is categorical
 #The limit of 6 unique values is somewhat arbitrary. It affects
 #the type of visual aid that will be presented.
 def isCategorical?
 # @x_profile[:isCategorical] =  (fCategorical? (x_values)) && (!fUnary? (x_values))
 # @y_profile[:isCategorical] =  (fCategorical? (y_values)) && (!fUnary? (y_values))
  @x_profile[:isCategorical] =  x_values.uniq.length.between? 2,6 
  @y_profile[:isCategorical] =  y_values.uniq.length.between? 2,6 
 end
 def isLogistical?
  @x_profile[:isLogistical] =   x_values.uniq.length == 2  #dependent variable only
 end
 def isUnary?
  @x_profile[:isUnary] =  x_values.uniq.length == 1  #dependent variable only
 end
 def isContinuous?
  #neither X nor Y are categorical. Required for standard regression
  @x_profile[:isContinuous] =  x_values.uniq.length > 6
  @y_profile[:isContinuous] =  y_values.uniq.length > 6
 end
# def isLogistical?
#  @y_profile[:isLinear] =  fLinear? (y_values)  #dependent variable only
# end

 	#execute the tests for normal distribution of the vectors

 #returns an array of the requested column, filtered to contain only the id of the desired metric
 #Will be useful for objects that need to create vectors to interface with Rserve
 def get_column(name, id)
 	metric_id_idx = metadata["column_names"].index("metric_id") #get index of metric_id column
 	col_idx = metadata["column_names"].index(name)              #get index of requested column
 	filtered = ds.map {|row| row if row[metric_id_idx] == id }.compact  #get array of only the requested id
  Rails.logger.info("#{self.class.name}:#{__method__} -- returning #{filtered.length} rows for parms:[#{''.concat(name,',',id)}]")
 	return filtered.map {|row| row[col_idx] }										#return requested column for requested metric
 end

	#
	#create class attributes with the DuserMetric data meeting the requirements of the Review object. 
	#also pluck the 3 attributes that we will use for the statistical functions and set up the metadata
	#to simplify creation of vectors to use in the R statistics app
	#
 def set_stat_data
 #full ActiveRelation dataset using params from review record
 	@dataset = DuserMetric.joins(:metric).for_duser(@review.duser_id).for_series([@review.metric_id, @review.event_id]).where("occur_dttm between ? and ?", @review.start_dt , @review.end_dt ).order(occur_dttm: :asc).select(:id,:occur_dttm,:metric_id,:value,:name)
 #view of dataset as an Array that will work for most statistical tests
 	@ds = @dataset.pluck(:metric_id,:value,:occur_dttm).map { |s| [s[0], s[1], s[2].strftime("%Y-%m-%d %H:%M")]}
 	get_meta
  @x_values = get_x_values
  @y_values = get_y_values

  #remove the outliers in @ds,@dataset and the x/y values arrays 
  Rails.logger.info("#{self.class.name}:#{__method__} -- dataset before remove_outliers: #{@dataset.length}")
  y_cuts = remove_outliers(@y_values,'metrics')
  if( ! y_cuts.empty? )
   Rails.logger.info("#{self.class.name}:#{__method__} -- outliers: #{y_cuts} ") 
   @dataset = @dataset.where.not("metric_id = ? and value in (?)",@review.metric_id,y_cuts) 
   @y_values = @y_values - y_cuts
   @ds.delete_if {|row|  row[0] == @review.metric_id and y_cuts.include?(row[1]) }
   Rails.logger.info("#{self.class.name}:#{__method__} -- new dataset sql: #{dataset.to_sql} ") 
  end

  Rails.logger.info("#{self.class.name}:#{__method__} -- dataset after y_cuts: #{@dataset.length}")
  #now do x values
  x_cuts = remove_outliers(@x_values,"events")
  if( ! x_cuts.empty?)
    @dataset = @dataset.where.not("metric_id = ? and value in (?)",@review.event_id,x_cuts)
    @x_values = @x_values - x_cuts
    @ds.delete_if {|row|  row[0] == @review.event_id and x_cuts.include?(row[1]) }
  end

  Rails.logger.info("#{self.class.name}:#{__method__} -- dataset after x_cuts: #{@dataset.length}")
  #populate the occur_dttm arrays after removing the outliers
  @x_occur_dttm = get_x_occur_dttm
  @y_occur_dttm = get_y_occur_dttm
 end

private
 #return the entire plucked dataset
 #returns a hash with the keys containing the name of each metric in the dataset, its metric id, and the 
 #array of column_names in the plucked dataset (@ds)
 #This allows the user to obtain this hash, and use it to access the list of metrics. For example, the 
 #y_axis metric name can be obtained by @metadata.key(@review.metric_id). This gets the hash item where
 #the key = name of the y_axis metric. The column_names key returns the array of column name in the 
 #plucked dataset.  They are in order, so @ds[0] is the metric_id data, @ds[1] the value data, etc.
 #NOTE: the array has to be 'mapped' to extract the column data, for example:  @ds.map {|rec| rec[0]}
 #to extact an array of all the first column values
 # 
 def get_meta
 	@metadata = @dataset.each_with_object({}) do |row, hash|
	  hash[row[:name]] = row[:metric_id]
	end
	@metadata["column_names"] = [:metric_id,:value,:occur_dttm].map(&:to_s)
  Rails.logger.info("#{self.class.name}:#{__method__} -- returning #{@metadata}")
	@metadata
 end
 #TODO - when we implement multiple regression, we'll have more than one event id.  Will need to change
 #this to return a hash of arrays, one array of values for each event id
 #independent variable(s)
 def get_x_values
 	get_column("value",@review.event_id)
 end

 #always the dependent variable (except in the special case of logistic regression).  
 def get_y_values
 	get_column("value",@review.metric_id)
 end
 def get_x_occur_dttm
 	get_column("occur_dttm",@review.event_id)
 end
 def get_y_occur_dttm
 	get_column("occur_dttm",@review.metric_id)
 end
end #StatSample class
