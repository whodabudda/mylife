class StatBase
    attr_reader   :duration,:span_hours,:review,:chartSeries
    attr_accessor :chart_info_erb, :error_msg
    def initialize(review,ss) 
        @review = review
        @duration = @review.end_dt - @review.start_dt
        @span_hours = @review.span
        #@chartSeries is an array where each element is a hash, formatted for use by HighCharts as a 'Series'. 
        #It contains name/value pairs of everything that defines the series, including 
        #its name, type, id, color, data  etc.  See Highcharts doc for more info
        # https://api.highcharts.com/highcharts/ 
        @chartSeries = [] 
        @error_msg = ''
        @chart_info_erb = 'chart_info'
        #the assumptions will be delegated to statSampleDelegate.
        @statSampleDelegate = ss
    end
    def who_am_i
    end 
    #delgate methods to StatSample, which has all the data for this analysis request.
    #TODO: look at what the super call does.  This class inherits from Class, so would expect a method missing error?
    def method_missing(method, *args, &block)
        if @statSampleDelegate.respond_to?(method)
          @statSampleDelegate.send(method, *args, &block)
        else
          super
        end
    end

    def respond_to_missing?(method, include_private = false)
      @statSampleDelegate.respond_to?(method) || super
    end
 
     # add series options to hash
    def setSingleValues(ndx)
        #Rails.logger.info "#{self.class.name}:#{__method__} --  Index is: #{ndx} and chartSeries is: #{chartSeries[ndx]} "
        chartSeries[ndx][:name] = @review.metric.name
        chartSeries[ndx][:color] = @review.metric.series_color
    end

    def setSeriesOption(name,value,idx)
        @chartSeries[idx][name.to_sym] = value
    end
    def metric
        return @review.metric
    end
    def error?
        return error_msg.empty? ? false : @error_msg
    end
    def valid?
        #debugger
        checkValid
        Rails.logger.info "#{self.class.name}:#{__method__} returning #{error_msg.empty?}, with message #{error_msg}"
        error_msg.empty? 
    end
    def checkValid
         if isInvalid?
            @error_msg="Not enough values to review.  Either expand the date ranges, the span window, or add more data points"
            Rails.logger.info "#{self.class.name}:#{__method__} error_msg is: #{error_msg}"
         end
     end
end