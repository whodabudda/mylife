class DuserMetricsController < ApplicationController
  before_action :set_duser_metric, only: [:show, :edit,:destroy]
  before_action :log_action
  respond_to :html, :json, :js
  
  # GET /duser_metrics
  # GET /duser_metrics.json
  def index
    @duser_metrics = DuserMetric.for_duser(current_duser.id).order(occur_dttm: :asc)
  end

  # GET /duser_metrics/1
  # GET /duser_metrics/1.json
  def show
  end

  # GET /duser_metrics/new
  def new
    #use the 
    @duser_metric = DuserMetric.new
    @duser_metric.duser_id = current_duser.id
    @duser_metric.metric_id = Metric.auth_to_view(current_duser.id).last.id

    #respond_modal_with @duser_metric
    #@duser_metric = DuserMetric.last(duser_id: current_duser.id).dup
  end

  # GET /duser_metrics/1/edit
  def edit
    @duser_metric = DuserMetric.find(params[:id])
  end

  # create a HighStock chart from a users data
  def chart

  end
  def filter_table_rows
    Rails.logger.info "Params: #{params}"
    #Rails.logger.info "filter_table_rows: #{params[:metric]}"
    #Rails.logger.info "filter_table_rows: #{params[:metric][:id]}"
    @m_id = 0
    #if  ! params[:metric][:id].empty? 
    #  @m_id =  params[:metric][:id].to_i 
    #end
    if  ! params[:id].empty? 
      @m_id =  params[:id].to_i 
    end
    respond_with @metric 
  end
  def show_unit_display
    Rails.logger.info "Params: #{params}"
    Rails.logger.info "show_unit_info: #{params[:duser_metrics]}"
    Rails.logger.info "show_unit_info: #{params[:duser_metrics][params[:id]][:metric_id]}"
    @new_id = params[:duser_metrics][params[:id]][:metric_id]

    #get the current DB record and save the old metric_id
    @duser_metric = DuserMetric.find(params[:id])
    @dm_old_metric_id = @duser_metric.metric_id

    #save duser_metric with the new metric_id
    @duser_metric.metric_id = @new_id 
    @duser_metric.save
    respond_with @duser_metric, @dm_old_metric_id 
  end
  if false
  def duser_metric_value 
    @duser_metric = DuserMetric.find(params[:id])
    @dm_old_metric_id = @duser_metric.metric_id

    #save duser_metric with the new metric_id
    @duser_metric.metric_id = @new_id 
    @duser_metric.save
  end
  end
  def create
    Rails.logger.info "Params: #{params}"
    if params.has_key?(:clone_id)
     @duser_metric = DuserMetric.find(params[:clone_id]).dup
    else
     @duser_metric = DuserMetric.new(duser_metric_params)
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
  # POST /duser_metrics
  # POST /duser_metrics.json
  def create_disable
    if params.has_key?(:clone_id)
     @duser_metric = DuserMetric.find(params[:clone_id]).dup
    else
     @duser_metric = DuserMetric.new(duser_metric_params)
    end
    respond_to do |format|
      if @duser_metric.save
        format.html { redirect_to @duser_metric, notice: 'Duser metric was successfully created.' }
        format.json { render :show, status: :created, location: @duser_metric }
        format.js { render :controller => :user_session, :action => :create , notice: 'Duser metric was successfully cloned.' }
      else
        format.html { render :new }
        format.json { render json: @duser_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /duser_metrics/1
  # PATCH/PUT /duser_metrics/1.json
  def update
    if @duser_metric = DuserMetric.update(params[:duser_metrics].keys, params[:duser_metrics].values)
      Rails.logger.info "Params id: #{params['id']}"
      @duser_metric = DuserMetric.find(params["id"])
      Rails.logger.info "After Update: #{@duser_metric}"
    else
      Rails.logger.info "Update Failed: #{@duser_metric}"
   # @duser_metric.update(duser_metric_params)
    end
    respond_with @duser_metric
  end

  def save_duser_metric_table
    respond_to do |format|
      if @duser_metric = DuserMetric.update(params[:duser_metrics].keys, params[:duser_metrics].values)
        format.html { redirect_to :controller => :user_session, :action => :home , notice: 'Duser metric was successfully updated.' }
        format.json { render :controller => :user_session, :action => :home , status: :ok, location: @duser_metric }
      else
        format.html { render :edit }
        format.json { render json: @duser_metric.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /duser_metrics/1
  # DELETE /duser_metrics/1.json
  def destroy
    @duser_metric.destroy
    respond_to do |format|
      format.html { redirect_to :controller => :user_session, :action => :home, notice: 'Duser metric was successfully destroyed.' }
      format.json { head :no_content }
      format.js
#      format.js { render :nothing => true }
    end
  end

  private
  def log_action
    Rails.logger.info "in: #{params[:controller]} : #{params[:action]}  for user: " + current_duser.id.to_s
    Rails.logger.info "params are: #{params.inspect}"
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_duser_metric
      @duser_metric = DuserMetric.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def duser_metric_params
      params.require(:duser_metric).permit(:value, :occur_dttm, :duser_id, :metric_id)
    end
end
