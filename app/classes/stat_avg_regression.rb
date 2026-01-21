
class StatAvgRegression < StatRegressionBase
    include StatAssumptions
    def initialize(review,ss) 
        super(review,ss)
    end

    #
    #
    def who_am_i
        "This is a chart showing one relationship between #{review.metric.name} and #{review.event.name}.
        The horizontal values (x-values) are the average number of hours before each #{review.metric.name},
        within each segment of #{span_hours} that fit between #{review.start_dt} and #{review.end_dt}.
        There is a data point for each span_hours segement that has data.
        The slanted line is a regression line that shows how the average distance of #{review.event.name} 
        from the measurment might influence the changes in #{review.metric.name}. 
        If the line slants up, it can be inferred that the event lowers the value of the metric 
        because the metric is higher as more aggregate time elapsed between the two,
        and if the line slants down, the opposite.
        "
    end
    def perform_analysis
        #some charts, like regression charts, will have more than one series. The chartSeries
        #variable is an array of hashes, where each element in the array has the hash elements
        #for a series.  Regression charts have a scatter graph series, and a line graph series.
        #We keep track of which series this object occupies by assigning it an index and 
        #writing its Highcharts elements to chartSeries[ndx].
        ndx = chartSeries.length  #ndx of the next empty slot
        #if the class name doesn't exist as an element in the existing hashes, start a new one 
        #with this class name, otherwise assign the index of the the discovered hash to ndx.
        if chartSeries.index {|h| h[:name] == self.class.name }.nil? 
            chartSeries[ndx] = {id: self.class.name}
        else
            ndx = chartSeries.index {|h| h[:name] == self.class.name }
        end

        Rails.logger.info "#{self.class.name}:#{__method__} --  Index is: #{ndx} and chartSeries is: #{chartSeries[ndx]} "
        #get the data for the series
        values = getDataArray
        if values.size > min_data_points
            chartSeries[ndx][:data] = values
            setSingleValues(ndx)
            chartSeries.push(getRegValues(ndx))  #create the series for the regression line
        end
        return values.size
    end


    def checkAssumptions
        validData? && (linear_regression? || unary_regression?)
    end

private

def getDataArray
  #debugger
  values = []
  Rails.logger.info "#{self.class.name}:#{__method__} --  dataset size #{dataset.size} "
  @events = []
  dataset.each do |rec|
    if (rec.metric_id == review.event_id) 
      @events.push rec
    else
      values.concat ( formatPoint(rec))    
    end
  end
  #return the array of hashes for the highcharts :data array
  #Rails.logger.info "#{self.class.name}:#{__method__} -- series data:  #{values} "
  Rails.logger.info "#{self.class.name}:#{__method__} -- created  #{values.length} points"
  values
end


    #format the point data for highcharts to use. 
    #For regressions, the y value is the metric, the x value the event.
    #All metrics and events have numeric values
    #return a hash useable by highcharts in its :data array

    #accumulate and average the events within the span window, so instead of a point for
    #every event, we'll have a point of the event average for every cluster of events 
    #within the window. 
def formatPoint(metric)
  values = []
  #Rails.logger.info "#{self.class.name}:#{__method__} -- event count: #{@events.length} metric(id,value): #{metric.id},#{metric.value}"
  cumulative_hrs = 0
  remove_me = []
  event_cnt = 0
  #@events.each_with_index do |rec,i|
  # puts "event index: #{i} -> id: #{rec.id}"
  #end
  @events.each do |rec|
    hours = 0
    hours = ((metric.occur_dttm - rec.occur_dttm)/3600).to_i if rec.metric_id == review.event_id
    #puts "rec.id: #{rec.id}  hours: #{ hours}  "
    if hours > @span_hours
       # puts "adding event #{rec.id} to remove_me list"
        remove_me.push rec
    else
       # puts "adding event #{rec.id} with #{hours} hours"

        cumulative_hrs += hours
        event_cnt += 1
    end
  end
  @events = @events - remove_me
  cumulative_hrs = (cumulative_hrs/event_cnt).to_i unless event_cnt < 1
      
  #putse"charting values x: #{cumulative_hrs}  y: #{ metric.value} for average of #{@events.length} events  "
  point = {"id": metric.id, "x": cumulative_hrs, "y": metric.value, "myData": metric.occur_dttm} unless cumulative_hrs == 0
  values.push point
  return values
end
end