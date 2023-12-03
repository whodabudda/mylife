class MetricsController < ApplicationController
  class NotAuthorized < StandardError
 end

  before_action :set_metric, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from NotAuthorized, with: :not_authorized
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
    def set_metric
        @metric = Metric.find(params[:id])
        raise NotAuthorized unless (@metric.duser_id == current_duser.id) or (Duser.system_user?(current_duser.id) == true)
    end
 
    def record_not_found
      render plain: "404 Not Found : no record for id: " #+ @metric.id + " user_id: " + @metric.duser_id, status: 404
    end
    def not_authorized
      flash[:notice] = "You don't have access to this record."
      redirect_back(fallback_location: root_path)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def metric_params
      params.require(:metric).permit(:name, :description, :duser_id, :unit_id,:series_color,:series_type)
    end
end
