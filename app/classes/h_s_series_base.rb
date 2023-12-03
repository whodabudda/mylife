class HSSeriesBase
    attr_accessor :user_id, :theMetric, :error_msg
#    attr_accessor :theMetric, :user_id, :stddev, :mean,:metric_id
#    attr_reader :event
    def initialize(metric_id, user_id) 
        @theMetric = Metric.find(metric_id)
        @user_id = user_id
        #@chartSeries is a hash formatted for use by HighCharts as a 'Series'. 
        #It contains name/value pairs of everything that defines the series, including 
        #its name, type, id, color, data  etc.  See Highcharts doc for more info
        # https://api.highcharts.com/highcharts/ 
        @chartSeries = {}
        @error_msg = ''
    end

    def write()
        @chartSeries
    end

    # add series options to hash
    def setSingleValues
        @chartSeries[:name] = theMetric.name
        @chartSeries[:id] = "metric"
        @chartSeries[:color] = theMetric.series_color
    end

    def setSeriesOption(name,value)
        @chartSeries[name.to_sym] = value
    end
    def metric
        return @theMetric
    end
    def error?
        return error_msg.empty? ? false : @error_msg
    end
    def valid?
        #debugger
        checkValid
        Rails.logger.info "HSSeriesBase:valid? returning #{error_msg.empty?}, with message #{error_msg}"
        error_msg.empty? 
    end
    def checkValid
         if @chartSeries[:data].size < 2
            Rails.logger.info "HSSeriesRegression:checkValid Setting error_msg "
            @error_msg="Not enough values to review.  Either expand the date ranges, the span window, or add more data points"
            Rails.logger.info "HSSeriesRegression:checkValid error_msg is: #{error_msg}"
         end
     end
       # getRegValues if @chartSeries[:data].size > 0
end