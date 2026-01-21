#
#See this excellent article on autoloading and the need for require_dependency
#http://urbanautomaton.com/blog/2013/08/27/rails-autoloading-hell/
#
require_dependency('h_s_chart_mgr')

class UserSessionController < ApplicationController
  respond_to :html, :json, :js
  before_action :authenticate_duser!
  helper_method :show_duser_chart
  #skip_forgery_protection only: [:chart]  # or skip_before_action :verify_same_origin_request

#  before_action :set_cache_headers, only: :home
  #def initialize
    #@@chart_mgr = HSChartMgr.new(request.env["warden"].user(:duser))
  #end
  def home
    Rails.logger.info "in: #{params[:controller]} : #{params[:action]}  for user: " + current_duser.id.to_s
    #displayed_series is used to show an editable table of the data in the chart. 
    #@displayed_series = DuserMetric.for_duser(current_duser.id).where("occur_dttm > ?", @chart_mgr.the_date ).order(occur_dttm: :asc)
    @displayed_series = DuserMetric.for_duser(current_duser.id).order(occur_dttm: :asc)
   # respond_with (@displayed_series)
   # render :home if stale?(@displayed_series)
  Rails.logger.info "Found #{@displayed_series.count} metrics charted. value of none is: #{@displayed_series.none?}"
   respond_to do |format|

    format.html do 
     if @displayed_series.none? 
        #@displayed_series = Array.new
        dm = DuserMetric.new
        dm.duser_id = current_duser.id 
        dm.metric_id = Metric.auth_to_view( current_duser.id).last.id 
        dm.value = 100
        dm.occur_dttm = DateTime.now
        dm.save
        @displayed_series = DuserMetric.for_duser(current_duser.id).order(occur_dttm: :asc)
       flash[:notice] = "You have not charted any metrics."
      flash[:notice] << " One has been added for you. Please feel free to change it,"
      flash[:notice] << " and use it as a starting point for your charting." 
     end
     render :home , locals:{displayed_series: @displayed_series}
    end
 end 
end
  def chart
    Rails.logger.info "in: #{params[:controller]} : #{params[:action]}  for user: " + current_duser.id.to_s
    #Rails.logger.info "in: #{params[:controller]} : #{params[:action]}  view_context: " + view_context.inspect
    @chart_mgr = HSChartMgr.new(current_duser.id)
    @chart_mgr.chart_title_text = current_duser.username.to_str + "s Biometric Chart"
    #responding with javascript that will be displayed raw.
    #ToDo: probably need to make this an ajax call and respond with js, and build the js object
    #in an erb.
    #@highchart_js = @chart_mgr.write
   respond_to do |format|
       format.js 
    end
  end

 # create a HighStock chart from a users data
  def show_duser_chart
    Rails.logger.info "in Helper show_duser_chart: #{params[:controller]} : #{params[:action]}  for user: " + current_duser.id.to_s
    #@chart_mgr = HSChartMgr.new(request.env["warden"].user(:duser))
  end

  def changes
    Rails.logger.info "in: #{params[:controller]} : #{params[:action]}"
    Rails.logger.info "Params: #{params}"
#    Rails.logger.info "Instance Variable @displayed_series: #{@displayed_series}"
    #@duser_metric = DuserMetric.find(@params[:id])
    #@duser_metric[0].value=@params[:value]
    #@duser_metric[0].occur_dttm=@params[:occur_dttm]
    if params[:jsaction] == "delete"
      remove_metric
      return
    end
    @dm = DuserMetric.find(params[:id])
    @dm.attribute_names.each do |attr_name|
      if params.has_key?(attr_name)   #if the data is in the params list
        if DuserMetric.columns_hash[attr_name].type.to_s == "datetime"
          rval = DateTime.strptime(params[attr_name],"%m/%d/%Y %H:%M")
        else
          rval = params[attr_name]
        end
        Rails.logger.info "Assign value for: #{attr_name} from #{@dm[attr_name]} to #{rval}"
        @dm[attr_name] = rval
      end
    end
    Rails.logger.info "occur_dttm: #{@dm.occur_dttm_change}"
    Rails.logger.info "value: #{@dm.value_change}"
    Rails.logger.info "Will save: #{@dm.attributes} "
    respond_to do |format|
      if @dm.save
#        format.html { redirect_to user_session_home, notice: 'Entry was successfully updated.' }
        format.json {render json: @dm, status => 200}
       # format.json { render json: @displayed_series, status: :success , location: @displayed_series }
#        format.json { status: :succeed }
      else
#        format.html { render :new }
        format.json { render json: @dm, status: :unprocessable_entity }
#        format.js 
      end
    end
  end

  def remove_metric
    @dm = DuserMetric.find(params[:id])
    @dm.destroy 
    respond_with(@dm) do |format|
       format.js { render :nothing => true, :layout => false  }
    end
  end
  def edit
    @duser_metric = DuserMetric.find(params[:id])
    respond_modal_with @duser_metric 
  end
  def show_unit_display
    Rails.logger.info "Params: #{params}"
    Rails.logger.info "show_unit_info: #{params[:duser_metrics]}"
    Rails.logger.info "show_unit_info: #{params[:duser_metrics][params[:id]][:metric_id]}"
    @tmp_id = params[:duser_metrics][params[:id]][:metric_id]
    @duser_metric = DuserMetric.find(params[:id])
    @duser_metric.metric_id = @tmp_id 
    @duser_metric.save
    respond_with @duser_metric 
  end

  def filter_table_rows
    Rails.logger.info "Params: #{params}"
    Rails.logger.info "filter_table_rows: #{params[:metric]}"
    Rails.logger.info "filter_table_rows: #{params[:metric][:id]}"
    @m_id = 0
    if  ! params[:metric][:id].empty? 
      @m_id =  params[:metric][:id].to_i 
    end
    respond_with @metric 
  end
  def update
    @duser_metric = DuserMetric.find(params[:id])
    @duser_metric.update
    respond_with(@duser_metric)
  end
  def create
    Rails.logger.info "Params: #{params}"
    if params.has_key?(:clone_id)
     @duser_metric = DuserMetric.find(params[:clone_id]).dup
    else
     @duser_metric = DuserMetric.new(user_session_params)
     @duser_metric.duser_id = current_duser.id
    end

    Rails.logger.info "Before Save: #{@duser_metric}"
    @duser_metric.save
    Rails.logger.info "After Save: #{@duser_metric}"
    @clone_id = params[:clone_id]
    respond_with(@duser_metric)
    Rails.logger.info "Done with Action"
  #  respond_to do |format|
  #    if @duser_metric.save
  #      format.html { redirect_to @duser_metric, notice: 'Duser metric was successfully created.' }
  #      format.json { render :show, status: :created, location: @duser_metric }
    #    format.js { render :controller => :user_session, :action => :create , notice: 'Duser metric was successfully cloned.' }
  #      format.js {}
  #    else
  #      format.html { render :new }
  #      format.json { render json: @duser_metric.errors, status: :unprocessable_entity }
  #    end
  # end
  end

  def add_metric
  end

  def add_event
  end

  def define_metric
  end

  def define_event
  end

  def refresh
    #chart_mgr.refresh
  end

  def set_chart_data
  end

  private
  def user_session_params
      params.require(:duser_metric).permit(:id,:value,:occur_dttm,:duser_id,:metric_id)
  end

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Mon, 01 Jan 1990 00:00:00 GMT"
  end
end

