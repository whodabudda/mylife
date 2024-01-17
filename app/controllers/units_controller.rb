class UnitsController < ApplicationController
  class NotAuthorized < StandardError
 end

  before_action :set_unit_for_change, only: [:edit, :update, :destroy]
  before_action :set_unit_for_view, only: [:show]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from NotAuthorized, with: :not_authorized
#  rescue_from ActiveRecord::RecordNotUnique, with: :not_unique

  respond_to :html, :json, :js
  layout 'modal', only: [:new,:edit]
  # GET /units
  # GET /units.json
  def index
    @units = Unit.auth_to_view(current_duser.id)
  end

  # GET /units/1
  # GET /units/1.json
  def show
  end

  # GET /units/new
  def new
    @unit = Unit.new
    @unit.duser_id = current_duser.id
#    respond_to do |format|
#      format.html { render :new }
#    end
    #render
  #respond_modal_with @unit , layout: "modal"
    
  end

  # GET /units/1/edit
  def edit
  end

  # POST /units
  # POST /units.json
  def create
    @unit = Unit.new(unit_params)
    raise NotAuthorized unless (@unit.duser_id == current_duser.id)  #just to be safe
    respond_to do |format|
      if @unit.save
        #format.html { redirect_to @unit, notice: 'Unit was successfully created.' }
        format.html { redirect_back fallback_location: root_path, notice: 'Unit was successfully created.' }
        format.json { render :show, status: :created, location: @unit }
      else
        format.html { render :new }
        format.js
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /units/1
  # PATCH/PUT /units/1.json
  def update
    respond_to do |format|
      if @unit.update(unit_params)
        format.html { redirect_back fallback_location: root_path , notice: 'Unit was successfully updated.' }
        format.json { render :show, status: :ok, location: @unit }
      else
        format.html { render :edit }
        format.js 
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    @unit.destroy
    Metric.where(unit_id: @unit.id).where( duser_id: @unit.duser_id).destroy_all

    respond_to do |format|
      format.html { redirect_to units_url, notice: 'Unit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.0
    # Only allow access to edit if user is system_user or owns the unit
    # guard against somone spoofing a different duser_id in the message
    def set_unit_for_view
      @unit = Unit.find(params[:id])
      raise RecordNotFound unless !@unit.nil?
      raise NotAuthorized unless [Duser.system_user, current_duser.id].include? @unit.duser_id 
    end
    def set_unit_for_change
      @unit = Unit.find(params[:id])

      raise RecordNotFound unless !@unit.nil?
      raise NotAuthorized unless current_duser.id == @unit.duser_id 

      Rails.logger.info "params has duser_id key: #{params.dig(:unit,:duser_id) }"
      if params.dig(:unit,:duser_id)
        #Rails.logger.info "params key same as user?: #{params.dig(:unit,:duser_id).to_i == current_duser.id }"
        raise NotAuthorized unless (params.dig(:unit,:duser_id).to_i == current_duser.id)
      end
    end

    def record_not_found
      render plain: "404 Not Found : no record for id: " #+ @metric.id + " user_id: " + @metric.duser_id, status: 404
    end
    def not_authorized
      Rails.logger.info "Raised NotAuthorized in: #{params[:controller]} : #{params[:action]}  for user: " + current_duser.id.to_s
      flash[:notice] = "You don't have access to this record."
      redirect_back(fallback_location: root_path)
    end

    def not_unique(exception)
      Rails.logger.info "Raised RecordNotUnique with error: #{exception.class} #{exception.message}"
      raise exception
      #render json: { error: exception }, status: :unprocessable_entity, notice:  "This name is already in your list" 
      redirect_back(fallback_location: root_path, notice:  "This name is already in your list" )
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def unit_params
      params.require(:unit).permit(:name, :displ_name, :duser_id)
    end

end
