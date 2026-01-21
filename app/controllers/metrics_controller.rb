class MetricsController < ApplicationController
  class NotAuthorized < StandardError
 end

  before_action :set_metric_for_change, only: [:edit, :update, :destroy ]
  before_action :set_metric_for_view, only: [:show]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from NotAuthorized, with: :not_authorized
  rescue_from ActiveRecord::RecordNotUnique, with: :not_unique
  respond_to :html, :json, :js

  #rescue from ActionController::RedirectBackError with: :some_redirect_def 
  # GET /metrics
  # GET /metrics.json
  def index
    @metrics = Metric.auth_to_view(current_duser.id)
  end

  # GET /metrics/1
  # GET /metrics/1.json
  def show
  end

  #When in highcharts and the user toggles one of the metrics, it will create a legendItemClick event that
  #we capture in chart.js.erb.  We perform an ajax call from there to this action in order to set the visible
  #column in the database. In this way, however the user left the chart, that is how they will see it again 
  #when it re-populates.  i.e. we save the preferences without the user having to take additional action.
  def toggle_metric_visible
    name = params[:name]
    @metric = Metric.where(name: name, duser_id: current_duser.id)
    @metric.count == 1 ? @metric = @metric.first : @metric = nil
    #TODO - figure out a good way to return early without the multiple render errors.
    if @metric.nil?
      Rails.logger.info "MetricsController::toggle_metric_visible-> metric is nil "
      return
    end
    if @metric.visible?
      @metric.visible = false
    else
      @metric.visible = true
    end
    #we do this ajax call from javascript, so we're not really updating the rest of the view.
    respond_to do |format|
      if @metric.save
        format.json { head :ok }
      else
        format.json { head :unprocessable_entity  }
      end
    end
  end

  # GET /metrics/new
  def new
    @metric = Metric.new
    @metric.duser_id = current_duser.id
  end

  # GET /metrics/1/edit
  def edit
  end

  # POST /metrics
  # POST /metrics.json
  def create
    @metric = Metric.new(metric_params)
    raise NotAuthorized unless current_duser.id == @metric.duser_id 
    respond_to do |format|
      if @metric.save
        format.html { redirect_back fallback_location: root_path, notice: 'Metric was successfully created.' }
        format.json { render :show, status: :created, location: @metric }
      else
        #format.js {render :js => "window.location.href='"+new_metric_path+"'", remote: true} 
        #format.js {redirect_to @metric, :new_metric_path}
        format.html { render :new }
        format.js
       # format.json { render json: @metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /metrics/1
  # PATCH/PUT /metrics/1.json
  def update
    respond_to do |format|
      if @metric.update(metric_params)
        format.html { redirect_back fallback_location: root_path , notice: 'Metric was successfully updated.' }
        format.json { render :show, status: :ok, location: @metric }
      else
        format.html { render :edit }
        format.js
        format.json { render json: @metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /metrics/1
  # DELETE /metrics/1.json
  def destroy
    @metric.destroy
    respond_to do |format|
      format.html { redirect_to metrics_url, notice: 'Metric was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metric_for_view
      @metric = Metric.find(params[:id])
      raise RecordNotFound unless !@metric.nil?
      raise NotAuthorized unless [Duser.system_user, current_duser.id].include? @metric.duser_id 
    end
    def set_metric_for_change
      @metric = Metric.find(params[:id])

      raise RecordNotFound unless !@metric.nil?
      raise NotAuthorized unless current_duser.id == @metric.duser_id 

      Rails.logger.info "params has duser_id key: #{params.dig(:metric,:duser_id) }"
      if params.dig(:metric,:duser_id)
        #Rails.logger.info "params key same as user?: #{params.dig(:metric,:duser_id).to_i == current_duser.id }"
        raise NotAuthorized unless (params.dig(:metric,:duser_id).to_i == current_duser.id)
      end
    end 
    def record_not_found
      render plain: "404 Not Found : no record for id: " #+ @metric.id + " user_id: " + @metric.duser_id, status: 404
    end
    def not_authorized
      flash[:notice] = "You don't have access to this record."
      redirect_back(fallback_location: root_path)
    end
    def not_unique(exception)
      #render plain: "500 #{@metric.name} is already in use " #+ @metric.id + " user_id: " + @metric.duser_id, status: 404
      #flash[:error] = "This name is already in use"
      #@metric.errors.add(:name,"SQL error: #{exception.message}")
      Rails.logger.info "MetricsController.not_unique Errors: #{@metric.errors.full_messages} Database: #{exception.message}  "
      respond_with @metric
      #redirect_back(fallback_location: root_path)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def metric_params
      params.require(:metric).permit(:name, :description, :duser_id, :unit_id,:series_color,:series_type,:visible)
    end
end
