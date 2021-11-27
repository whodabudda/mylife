
class HSSeries
  attr_accessor :theMetric, :current_user, :stddev
    def initialize(mrec, current_user) 
        @theMetric = mrec
        @current_user = current_user
        @dataset = DuserMetric.select(:id, :occur_dttm, :value).for_duser(@current_user).for_series(@theMetric.id).order(occur_dttm: :asc)
        @chartSeries = {}
        @stddev = 0
        @mean = 0
        #
        #we will display events as a scatter chart and show only their position as the stddev for all points 
        #

        if theMetric.series_type == 'event'
            #select_all returns an array of ActiveRecord::Results. 
            #Need to change it to an arry of result hashes, then get the value of the hash, in this case
            #just the first hash.  There will only be one record returned by query if there are charts for
            #this duser/metric pair.
           @stddev =  DuserMetric.connection.select_all("select stddev(value) from duser_metrics where duser_id = #{@current_user} and metric_id = #{theMetric.id}").to_a[0].values[0]
           @mean =  DuserMetric.connection.select_all("select avg(value) from duser_metrics where duser_id = #{@current_user} and metric_id = #{theMetric.id}").to_a[0].values[0].to_f
        end
        setSingleValues
        setDataValues
    end
    def write()
        @chartSeries
    end

    # add an object to the array
    def setSingleValues
        @chartSeries[:name] = theMetric.name
        @chartSeries[:id] = theMetric.name
        @chartSeries[:color] = theMetric.series_color
        @chartSeries[:type] = (theMetric.series_type == 'metric' ? 'line' : 'scatter')
        @chartSeries[:yAxis] = "events" if theMetric.series_type == "event" 
    end
    def setDataValues
        values = []
        @dataset.each do |rec| 
          values.push ( formatPoint(rec))
        end
        @chartSeries[:data] =  values
    end
    def formatPoint(rec)
      return {"id": rec.id, "x": rec.occur_dttm.to_i * 1000, "y": stddevCount(rec.value), "myData": rec.value}
#      return [rec.occur_dttm.to_i * 1000,rec.value]
#          return {"id": rec.id, "x": rec.occur_dttm.to_i * 1000, "y": rec.value, "myData": rec.value}
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

    def remove
    end
    def toggleDisplay
    end
    # will be either a metric or an event type of series,  which in turn determines the subclass of HSPoint
    def type 
    end


end