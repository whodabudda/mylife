
#writes out the javascript for Charts (Highcharts/highstock)

class HSChartMgr
    attr_accessor :renderto_div_tag,:chart_title_text,:yaxis_title_text,:xaxis_title_text
   def initialize(userid)
      #
      #Set all the highchart variables here.  They will be substituted into 
      #the generated code.
      #
      #current_user = request.env["warden"].user(:duser)
      #Either pass in the user id, or get it from warden.  
      #The Devise helper 'current_duser' is NOT available to this class.  
      @current_user = userid
      @theChart = ""
      @allSeries = []
   end

    def user_name
      Duser.find(@current_user).username
    end
    def all_series

      Rails.logger.info "in: #{self}.#{__method__} " 
      #
      #Get all charted metrics defined by the system or this user that were actually charted.
      #
      #01/27/24 remove system user from DuserMetric where clause.  Only want to select Metrics
      #actually charted in DuserMetric.  Don't want to select DuserMetrics that the system 
      #user may have charted (even though there shouldn't be any). Should still return Metric
      #rows that are owned by the system user.
      @metrics = Metric.select(:id,:name,:series_color,:series_type,:visible).where(id: DuserMetric.select("metric_id").where("duser_id = ? ",@current_user ))
      #
      #For each defined metric, get the users's charted values for that metric 
      #TODO Add ability for use to select which metrics they want to be active when chart is first displayed.
      @metrics.each do |mrec| 
        #all the charted values for this mrec
        ser = HSSeries.new(mrec,@current_user)
        @allSeries.push(ser) unless ser.write[:data].length == 0
        #@the_series = DuserMetric.select(:occur_dttm, :value).for_duser(@current_user).for_series(mrec.id).order(occur_dttm: :asc)
        #this_series = "  name: '#{mrec.name}', color: '#{mrec.series_color}', lineWidth: 0,marker: {enabled: true, radius: 7 }, states: {hover: {lineWidthPlus: 0 } },tooltip: {valueDecimals: 2 },visible: #{mrec.name == "Run" ? "false" : "true"}, #{get_group_option(mrec.name)} , data: ["
      end
      return @allSeries
    end
end