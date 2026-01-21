
class StatAvgBargraph < StatBase
    include StatAssumptions
    def initialize(review,ss) 
        super(review,ss)
    end

    #
    #
    def perform_analysis
        ndx = chartSeries.length
        if chartSeries.index {|h| h[:name] == self.class.name }.nil? 
            chartSeries[ndx] = {id: self.class.name}
        else
            ndx = chartSeries.index {|h| h[:name] == self.class.name }
        end

        Rails.logger.info "#{self.class.name}:#{__method__} --  Index is: #{ndx} and chartSeries is: #{chartSeries[ndx]} "
        chartSeries[ndx][:data] = getDataArray
        setSingleValues(ndx)
        setSeriesOption(:type, :scatter, ndx)
        #setSeriesOption(:pointWidth, 20, ndx)
    end

    def checkAssumptions
        validData? && (unary_regression?)
    end
    def who_am_i
        "This is a chart showing a relationship between #{review.metric.name} and #{review.event.name}.
        The horizontal values (x-values) are the average amount of #{review.event.name} before each #{review.metric.name},
        within each segment of #{span_hours} that fit between #{review.start_dt} and #{review.end_dt}.
        There is a data point for each span_hours segement that has data.
        "
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
  Rails.logger.info "#{self.class.name}:#{__method__} -- series data:  #{values} "
  #values = values.reject &:blank?
  values = values.compact
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
  processed_count = 0
  remove_me = []
  @events.each_with_index do |rec,i|
    hours = 0
    hours = ((metric.occur_dttm - rec.occur_dttm)/3600).to_i  #if rec.metric_id == review.event_id
    #if the event occurred more than span_hours before the metric, skip it. Otherwise, add
    #the event value to the accumulator
    if hours > @span_hours
        remove_me.push rec
    else
        cumulative_hrs += rec.value
        processed_count += 1
    end
  end
  #remove the processed events from the list
  @events = @events - remove_me
  if cumulative_hrs > 0
      #average out the event hours in the accumulator
      cumulative_hrs = (cumulative_hrs/processed_count).to_i 
      
      #puts "charting values x: #{cumulative_hrs}  y: #{ metric.value} for average of #{@events.length} events  "
      point = {"id": metric.id, "x": cumulative_hrs, "y": metric.value, "myData": metric.occur_dttm}
      values.push point
  end
  return values
end
end