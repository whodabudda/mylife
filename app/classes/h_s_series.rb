
class HSSeries
  attr_accessor :theMetric, :current_user, :stddev
        attr_accessor :dataset, :stddev, :mean
        attr_reader :event
    def initialize(mrec, current_user) 
        @event = mrec.series_type == 'event' ? true : false
        @theMetric = mrec
        @current_user = current_user
        if dataset.nil?
            @dataset = DuserMetric.select(:id, :occur_dttm, :value).for_duser(@current_user).for_series(@theMetric.id).order(occur_dttm: :asc)
        else
            @dataset = dataset
        end

        @chartSeries = {}
        @stddev = 0
        @mean = 0
        #
        #we will display events as a scatter chart and show only their position as the stddev for all points 
        #

        if event?
            #select_all returns an array of ActiveRecord::Results. 
            #Need to change it to an arry of result hashes, then get the value of the hash, in this case
            #just the first hash.  There will only be one record returned by query if there are charts for
            #this duser/metric pair.
           @stddev =  DuserMetric.connection.select_all("select stddev(value) from duser_metrics where duser_id = #{@current_user} and metric_id = #{theMetric.id}").to_a[0].values[0]
           @mean =  DuserMetric.connection.select_all("select avg(value) from duser_metrics where duser_id = #{@current_user} and metric_id = #{theMetric.id}").to_a[0].values[0].to_f
           #
           #TODO: the following sql works as well and is a little more readable.  Switch over and test.
           #
           #DuserMetric.connection.select_all("select stddev(value) from duser_metrics where duser_id = 2 and metric_id = 6").first["stddev(value)"]
           #
        end
        setSingleValues
        setDataValues
    end
    def write()
        @chartSeries
    end

    # add series options to hash
    def setSingleValues
        @chartSeries[:name] = theMetric.name
        @chartSeries[:id] = theMetric.name
        @chartSeries[:color] = theMetric.series_color
        @chartSeries[:visible] = (theMetric.visible ? true : false)
        @chartSeries[:type] = (theMetric.series_type == 'metric' ? 'line' : 'scatter')
        @chartSeries[:yAxis] = "events" if theMetric.series_type == "event" 
    end

    def getDataArray
        values = []
        @dataset.each do |rec| 
          values.push ( formatPoint(rec))
        end
        values
    end
    # add an array of series data points to the hash. The hash key is ':data' and its value is the array of points
    def setDataValues
        @chartSeries[:data] =  getDataArray
    end

    #format the point data for highcharts to use. The datetime is stored in seconds and needs to be converted
    #to milliseconds for highcharts. stddevCount will change the value to a standard deviation if the 
    #metric type is an 'event'
    def formatPoint(rec)
      return {"id": rec.id, "x": rec.occur_dttm.to_i * 1000, "y": stddevCount(rec.value), "myData": rec.value}
    end

    # if the series is an event type, calculate how many stddev's this value is away from the mean
    # See https://www.statisticshowto.com/wp-content/uploads/2013/08/CALCULATE-A-Z-SCORE-2.jpg
    def stddevCount(v)
     if  (@theMetric.series_type == 'event')
        if  !(@stddev.nil? or @stddev == 0)
          return z = (v-@mean)/@stddev
        end
     end
     #if the conditions fall through, just return the value
     return v
    end

    def event?
        return event
    end
end