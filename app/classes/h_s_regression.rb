#Select all the duser metric events in the window of time being looked at

#todo get these from parameters
time_overall_start = DateTime.new(2020,12,1,0,0) 
time_overall_end = DateTime.new(2021,6,1,0,0) 
time_window_for_metrics = 48.hours #hrs
current_duser
metric_id

#get all events in the overall time, plus the next event after the time frame as a bookend
#for getting the metrics.
DuserMetric.joins(:metric).for_duser(2).for_series("6,9").where("occur_dttm between ? and ?", Date.new(2020,12,1) , Date.new(2021,12,1)).order(occur_dttm: :asc).pluck(:id,:occur_dttm,:metric_id,:value,:series_type)

de = DuserMetric.select(:id, :occur_dttm, :value)
	.for_duser(2)
	.for_series(6)   #run
	.where("occur_dttm between ? and ?", time_overall_start.to_date , time_overall_end.to_date)
	.order(occur_dttm: :asc)

i = 0
while i < @de.size
	last_event_dttm = de[i].occur_dttm
	DuserMetric.select(:id, :occur_dttm,  :value)
	.for_duser(2)
	.for_series(1)  #BP
	.where("(occur_dttm between ? and ? ) and occur_dttm < ?", last_event_dttm - time_window_for_metrics ,( i+1].nil? ? time_overall_end.to_date : de[i + 1].occur_dttm), de.last.occur_dttm )
	i= i+1
end
#for each event returned

#	select all the metrics that occured within either 24,48, 72 hrs of the event
#	for each of these metrics
#		Add a point to the array that we need to build for the R data frame
#		The point will be the [event,metric] values (x,y)
#	end
#end
#Create the R data frame from the array
#run the regression
#parse results and format a response that includes the data array, a scatter plot, and a summary of coefficients and #pvalue

