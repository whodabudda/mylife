
class StatRegressionBase < StatBase
    include StatAssumptions
    attr_accessor :slope,:intercept,:pearson_r,:min_data_points 
    def initialize(review,ss) 
        super(review,ss)
        @slope = 0
        @intercept = 0
        @pearson_r = 0
        @theMetric = Metric.find(review.metric_id)
        @chart_info_erb = 'regression_chart_info'  #the name of the erb to display info under the charta
        @min_data_points = 6
    end

    def checkAssumptions
        validData? && linear_regression?
    end

    # add series options to hash
    def setSingleValues(ndx)
        #@chartSeries[:color] = theMetric.series_color
        #https://api.highcharts.com/highstock/series.linearregression
        #examples: http://jsfiddle.net/BlackLabel/zo5or65e/
        #          http://www.java2s.com/example/javascript/highcharts/basic-default-settings-linear-regression-with-equation-in-the-legend.html
        #@ndx = ndx  set the instance variable so getRegValues knows where to get data
        super(ndx)
        chartSeries[ndx][:type] = "scatter"
        chartSeries[ndx][:yAxis] = 0
       # Rails.logger.info "#{self.class.name}:#{__method__} --  Index is: #{@ndx} and chartSeries is: #{chartSeries[@ndx]} "
    end
    #placeholder method to avoid method-missing error.
    def after_analysis_review(vx,vy)
    end
    
# return an array of hashes that is the series for the regression line.
# the regression line is calculated from the data values in the series data
# for the child object's scatter graph.  Therefore, setSingleValues needs to 
# be called before this function so that the @idx is set. (@idx contains the
# index of the hash in the chartSeries array that has the data)
# 
def getRegValues(ndx)

    sum_x = 0
    sum_y = 0
    a = @chartSeries[ndx][:data].compact
    Rails.logger.info ("#{self.class.name}:#{__method__} --a.class: #{a.class} a.data: #{a} ")
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

    Rails.logger.info ("#{self.class.name}:#{__method__} -- x_values: #{x_values.size} y_values: #{y_values.size} n: #{n} sum_x: #{sum_x} sum_y: #{sum_y} sum_xy: #{sum_xy} sum_x_squared: #{sum_x_squared} numerator: #{numerator} denominator: #{denominator} intercept: #{intercept} slope: #{slope} ")

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
      y = (slope * xv) + intercept
      reg_data.push (formatRegLine(reg_data.count, xv,y,"y = mx + b"))
    end
    @reg_line_series[:name] = @theMetric.name + " regression line"
    @reg_line_series[:id] =  "RegressionLine"
    @reg_line_series[:type] = "line"
   # @reg_line_series[:color] = "red"
   # @reg_line_series[:yAxis] = "metric"
    @reg_line_series[:data] = reg_data
    return @reg_line_series
end
def show_result
    "slope: #{self.slope}  intercept: #{self.intercept} pearson_r: #{self.pearson_r} " 
end
end