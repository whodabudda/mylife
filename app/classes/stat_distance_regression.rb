
class StatDistanceRegression < StatRegressionBase
 include StatAssumptions
    def initialize(review,ss) 
        super(review,ss)
    end

    def perform_analysis
        #TODO - refactor to DRY up the ndx assignment
        ndx = chartSeries.length
        if chartSeries.index {|h| h[:name] == self.class.name }.nil? 
            chartSeries[ndx] = {id: self.class.name}  #assigns hash to the empty element at array.length
        else
            ndx = chartSeries.index {|h| h[:name] == self.class.name }
        end
        Rails.logger.info "#{self.class.name}:#{__method__} --  Index is: #{ndx} "
        chartSeries[ndx][:data] = getDataArray
        setSingleValues(ndx)
        chartSeries.push(getRegValues(ndx))  #create a new element for the regression line series
    end
    def who_am_i
        "Chart of the relationship between the metrics (#{review.metric.name}) and the events (#{review.event.name}).
        The points are calculated from each #{review.metric.name} between #{review.start_dt} and #{review.end_dt}.
        The x-values (horizontal scale) represent events of #{review.event.name} that happened within #{span_hours} hours of #{review.metric.name}.
        The slanted line is called a regression line.  It shows how #{review.event.name} might influence 
        the changes in #{review.metric.name}. 
        We calculate the x-values by giving more weight to the #{review.event.name}s that are closer in time to the
        #{review.metric.name}, so that the event value is higher the closer in time it is to the metric.
        If the line slants down, it can be inferred that the event 
        lowers the #{review.metric.name}, and if the line slants up, the opposite.
        "
    end
    def checkAssumptions

        validData? && (linear_regression? || unary_regression?)
    end

private
 
#creates a data point for each event in the span window leading up to a metric. 
#x value is the distance in hours of the event from the metric. y value is the metric value.
#does not retain the events for the next metric, i.e. once a metric is hit, the next
#reading resets the event list, so if the next reading is a metric, the event x value will be zero.
#one effect of this is we can have a lot of values of zero for the x axis.
def getDataArray
  #debugger
  values = []
  Rails.logger.info "#{self.class.name}:#{__method__} -- dataset size #{dataset.size} "
  events = []
  dataset.each do |rec|
    if (rec.metric_id == review.event_id) 
      events.push rec
    else
      values.concat ( formatPoint(events,rec))    
    end
  end
  #return the array of hashes for the highcharts :data array
  #Rails.logger.info "#{self.class.name}:#{__method__} --  series data:  #{values} "
  Rails.logger.info "#{self.class.name}:#{__method__} -- created  #{values.length} points"
  values.compact
end


    #format the point data for highcharts to use. 
    #For regressions, the y value is the metric, the x value the event.
    #All metrics and events have numeric values
    #in this view we chart the x value as the distance in hours of the event from the metric.
    #return a hash useable by highcharts in its :data array
def formatPoint(events,metric)
  values = []

  Rails.logger.info "#{self.class.name}:#{__method__} -- #{events.size} elements in event array "
  events.each_with_index do |rec,i|
    hours = 0
    #result is in seconds, so divide by 3600 to get hours
    Rails.logger.info "#{self.class.name}:#{__method__} -- values to calculate hours: #{metric.occur_dttm} rec.value: #{rec.occur_dttm} "
    hours = ((metric.occur_dttm - rec.occur_dttm)/3600).to_f # if rec.metric_id == review.event_id
    if hours > @span_hours  #toss events charted more than span_hours before the metric
        Rails.logger.info "#{self.class.name}:#{__method__} -- hours #{hours}  removing #{events[i]} "
        events.delete_at(i)
        next rec
    else
        h_tmp = hours
        #The rec.value is the numeric value for the event, ex: hours of exercise. Divide that by the number
        #of hours the event occured prior to the metric, ex: Blood Pressure.  This gives a weight to the 
        #possible effect of the event on the metric.  The closer in time, the higher the weight.
        hours = ((rec.value / hours.to_f) * 100).round
        Rails.logger.info "#{self.class.name}:#{__method__} -- created x value: #{hours} from event distance: #{h_tmp} hours distance "
    end
    point = {"id": metric.id, "x": hours, "y": metric.value, "myData": metric.occur_dttm}
    values.push point
  end
  return values
end
end