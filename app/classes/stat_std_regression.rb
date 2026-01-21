
class StatStdRegression < StatRegressionBase
    include StatAssumptions
    def initialize(review,ss) 
        super(review,ss)
    end

    def perform_analysis
        ndx = chartSeries.length
        if chartSeries.index {|h| h[:name] == self.class.name }.nil? 
            chartSeries[ndx] = {id: self.class.name}
        else
            ndx = chartSeries.index {|h| h[:name] == self.class.name }
        end
        Rails.logger.info "#{self.class.name}:#{__method__} --  Index is: #{ndx} "
        values = getDataArray
        if values.size > min_data_points
            chartSeries[ndx][:data] = values
            setSingleValues(ndx)
            chartSeries.push(getRegValues(ndx))  #create the series for the regression line
            vx = values.map {|row| row[:x]} 
            vy = values.map {|row| row[:y]} 
            after_analysis_review(vx,vy)
        end
        return values.size
   end

    def checkAssumptions
        validData? && linear_regression? && !unary_regression?
    end

private
    def getDataArray
        #debugger
        values = []
        Rails.logger.info "#{self.class.name}:#{__method__} -- dataset size #{dataset.size} "
        curr_event = nil
        dataset.each do |rec| 
            curr_event = rec if rec.metric_id == review.event_id
            if (!curr_event.nil?) and (rec.metric_id == review.metric_id) and 
                ((curr_event.occur_dttm + @span_hours.hours) > rec.occur_dttm)
                values.push ( formatPoint(curr_event,rec)) 
            end
        end
        Rails.logger.info "#{self.class.name}:#{__method__} -- Number of Values to chart #{values.size} "

        #return the array of hashes for the highcharts :data array
        #Rails.logger.info "#{self.class.name}:#{__method__} --  series data:  #{values} "
        values
    end
    def after_analysis_review(vx,vy)
     independent_observations(vx,vy)
     r = getResiduals(vx,vy)
     isNormalDist?(r)
     isHomoSkedastic?(vx,vy)   #leave out for now due to problems running leveneTest. It apparently wants factor data
                                #for one of the vectors
    end

    #format the point data for highcharts to use. 
    #For regressions, the y value is the metric, the x value the event.
    #All metrics and events have numeric values
    #return a hash useable by highcharts in its :data array
    def formatPoint(event,metric)
      return {"id": metric.id, "x": event.value, "y": metric.value, "myData": metric.occur_dttm}
    end
end