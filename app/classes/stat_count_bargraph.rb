
class StatCountBargraph < StatBase
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
        setSeriesOption(:type, :column, ndx)
        setSeriesOption(:pointWidth, 20, ndx)
    end

    def checkAssumptions
        validData? 
    end
    def who_am_i
        "This is a chart showing a relationship between #{review.metric.name} metrics and #{review.event.name} events.
        The horizontal values (x-values) are the number of #{review.event.name}s
        that happened withiin #{span_hours} hours a #{review.metric.name}. 
        The y-value is the average #{review.metric.name} for all the prior events of the same frequency.
        There is a data point for each segement that has the same frequency of events.
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
  #Rails.logger.info "#{self.class.name}:#{__method__} -- series data:  #{values} "

  Rails.logger.info "#{self.class.name}:#{__method__} -- returning #{values.compact.to_json}"
  #At this point, values have the y values and x counts, i.e. number of times x occured
  #in the span_hours before y.  Need to average the y values for each discrete count.
  #first get the range of x
  vrange = []
  values = values.compact
  vrange = values.map{|v| v[:x]}.uniq
  Rails.logger.info "#{self.class.name}:#{__method__} -- x-values Range: #{vrange}"
  vrange.each do |v|
        Rails.logger.info "#{self.class.name}:#{__method__} -- on range: #{v}"
        #get the subset of y values for all rows of x == v
        vt =  values.map{|m| m if m[:x] == v}.compact.map{|m| m[:y]}  
        #change the y values to the average of all the y values for x == v
        values.map{|m| m[:y] = (vt.reduce(:+) / vt.length) if m[:x] == v }
  end
  values.compact
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
  @events.each_with_index do |rec,i|
    hours = 0
    hours = ((metric.occur_dttm - rec.occur_dttm)/3600).to_i if rec.metric_id == review.event_id
    #puts "rec.id: #{rec.id}  hours: #{ hours}  "
    if hours > @span_hours
       # puts "adding event #{rec.id} to remove_me list"
        remove_me.push rec
    else
       # puts "adding event #{rec.id} with #{hours} hours"

        cumulative_hrs += 1
    end
  end
  @events = @events - remove_me

  Rails.logger.info "#{self.class.name}:#{__method__} -- event count: #{@events.length} metric(id,value): #{metric.id},#{metric.value}"
  point = {"id": metric.id, "x": cumulative_hrs, "y": metric.value, "myData": metric.occur_dttm} #unless cumulative_hrs == 0
  values.push point
  return values
end
end