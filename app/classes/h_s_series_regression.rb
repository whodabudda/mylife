
require_dependency('h_s_series_base')
class HSSeriesRegression < HSSeriesBase
    attr_accessor :dataset,:slope,:intercept,:pearson_r
    def initialize(review) 
        @review = review
        @slope = 0
        @intercept = 0
        @pearson_r = 0
        super(@review.metric_id,@review.duser_id)
#        @theEvent = Metric.find(@review.event_id)
        @duration = @review.end_dt - @review.start_dt
        @span_hours = @review.span
        @dataset = DuserMetric.joins(:metric).for_duser(user_id).for_series([@review.metric_id, @review.event_id]).where("occur_dttm between ? and ?", @review.start_dt , @review.end_dt ).order(occur_dttm: :asc).select(:id,:occur_dttm,:metric_id,:value,:series_type)
        setSingleValues
        setDataValues
    end

#    def event
#        return @theEvent
#    end


    # add series options to hash
    def setSingleValues
        super
        #@chartSeries[:color] = theMetric.series_color
        #https://api.highcharts.com/highstock/series.linearregression
        #examples: http://jsfiddle.net/BlackLabel/zo5or65e/
        #          http://www.java2s.com/example/javascript/highcharts/basic-default-settings-linear-regression-with-equation-in-the-legend.html
        setSeriesOption(:name , theMetric.name)
        @chartSeries[:id] = "metric"
        @chartSeries[:color] = theMetric.series_color
        @chartSeries[:type] = "scatter"
        @chartSeries[:yAxis] = 0
        #@chartSeries[:regression] = "true"
    end

    # add an array of series data points to the hash. The hash key is ':data' and its value is the array of points
    def setDataValues
        @chartSeries[:data] =  getDataArray
    end


    def getDataArray
        #debugger
        values = []
        Rails.logger.info "HSSeriesRegression:getDataArray dataset size #{@dataset.size} "
        curr_event = nil
        @dataset.each do |rec| 
            curr_event = rec if rec.series_type == "event"
            if (!curr_event.nil?) and (rec.series_type == "metric") and ((curr_event.occur_dttm + @span_hours.hours) > rec.occur_dttm)
                values.push ( formatPoint(curr_event,rec)) 
            end
        end
        #return the array of hashes for the highcharts :data array
        Rails.logger.info "HSSeriesRegression.getDataArray: series data:  #{values} "
        values
    end


    #format the point data for highcharts to use. 
    #For regressions, the y value is the metric, the x value the event.
    #All metrics and events have numeric values
    #return a hash useable by highcharts in its :data array
    def formatPoint(event,metric)
      return {"id": metric.id, "x": event.value, "y": metric.value, "myData": metric.occur_dttm}
    end

# return an array of hashes that is the series for the regression line.
# the regression line is calculated from the data values in the dataset.
def getRegValues

    sum_x = 0
    sum_y = 0
    a = @chartSeries[:data]
    a.each do |hash| 
        sum_x += hash[:x] ; sum_y += hash[:y]  
    end
    x_values = a.map{|x| x[:x]}
    y_values = a.map{|x| x[:y]}
    n = a.size
    sum_x_squared = x_values.map { |x| x**2 }.reduce(:+)
    sum_y_squared = y_values.map { |y| y**2 }.reduce(:+)
    sum_xy = x_values.zip(y_values).map { |x, y| x * y }.reduce(:+)

    numerator = (n * sum_xy) - (sum_x * sum_y)
    denominator = Math.sqrt((n * sum_x_squared - sum_x**2) * (n * sum_y_squared - sum_y**2))


    self.slope = (n * sum_xy - sum_x * sum_y) / (n * sum_x_squared - sum_x**2).to_f  #at least one must be coerced to float
    self.intercept = (sum_y - slope * sum_x) / n
    self.pearson_r = numerator / denominator

    Rails.logger.info "HSSeriesRegression.getRegValues: x_values: #{x_values.size} y_values: #{y_values.size} n: #{n} sum_x: #{sum_x} sum_y: #{sum_y} sum_xy: #{sum_xy} sum_x_squared: #{sum_x_squared} intercept: #{intercept} slope: #{slope} pearson_r: #{pearson_r}"
    Rails.logger.info show_result

    return createRegLine( slope, intercept,x_values)
end
def formatRegLine(c,x,y,mydata)
    return {"id": c, "x": x, "y": y, "myData": mydata }
end

def createRegLine(slope,intercept,x_values)
    @reg_line_series = {}
    reg_data = []
    x_values.each do |xv|
#      reg_data.push {"id": reg_data.count, "x": xv, "y": (slope * xv) + intercept, "myData": "y = #{xv} * #{slope} + #{intercept}"}
      y = (slope * xv) + intercept
      reg_data.push (formatRegLine(reg_data.count, xv,y,"y = mx + b"))
    end
    @reg_line_series[:name] = theMetric.name + " regression line"
    @reg_line_series[:id] =  "regression line"
    @reg_line_series[:type] = "line"
    @reg_line_series[:color] = "red"
    @reg_line_series[:yAxis] = "metric"
    @reg_line_series[:data] = reg_data
    return @reg_line_series
end
def show_result
    "slope: #{self.slope}  intercept: #{self.intercept} pearson_r: #{self.pearson_r}"
end

#        sumx = 0
#        sumy = 0
#        a = write()
#        a[:data].each do |hash| 
#            sumx += hash[:x] ; sumy += hash[:y]  
#        end
#        dims = a[:data].size
#        xy = sumx * sumy
#        x2 = sumx * sumx
#        y2 = sumy * sumy
#        y_int = ((sumy * x2) - (sumx * xy)) / ((dims * x2) - (sumx * sumx))
#        slope = ((dims * xy) - xy)) / ((dims * x2) - (sumx * sumx))
end