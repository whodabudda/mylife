class DuserMetricsController < ApplicationController
  before_action :set_duser_metric, only: [:show, :edit, :update, :destroy]

  # GET /duser_metrics
  # GET /duser_metrics.json
  def index
    @duser_metrics = DuserMetric.all
  end

  # GET /duser_metrics/1
  # GET /duser_metrics/1.json
  def show
  end

  # GET /duser_metrics/new
  def new
    @duser_metric = DuserMetric.new
  end

  # GET /duser_metrics/1/edit
  def edit
  end

  # create a HighStock chart from a users data
  def chart
    
  end

  # POST /duser_metrics
  # POST /duser_metrics.json
  def create
    @duser_metric = DuserMetric.new(duser_metric_params)

    respond_to do |format|
      if @duser_metric.save
        format.html { redirect_to @duser_metric, notice: 'Duser metric was successfully created.' }
        format.json { render :show, status: :created, location: @duser_metric }
      else
        format.html { render :new }
        format.json { render json: @duser_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /duser_metrics/1
  # PATCH/PUT /duser_metrics/1.json
  def update
    respond_to do |format|
      if @duser_metric.update(duser_metric_params)
        format.html { redirect_to @duser_metric, notice: 'Duser metric was successfully updated.' }
        format.json { render :show, status: :ok, location: @duser_metric }
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
      format.html { redirect_to duser_metrics_url, notice: 'Duser metric was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_duser_metric
      @duser_metric = DuserMetric.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def duser_metric_params
      params.require(:duser_metric).permit(:value, :occur_dttm, :duser_id, :metric_id)
    end
end
