require 'rserve'
#require_dependency('h_s_series_regression')
class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show edit update destroy home]
  before_action :show_params
  respond_to :html, :json, :js

  # GET /reviews or /reviews.json
  def index
    @reviews = Review.all
  end
  def select_modal
    @reviews = Review.all
  end
  # GET /reviews/1 or /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews or /reviews.json
  def create
    @review = Review.new(review_params)

    respond_to do |format|

      if @review.save
        format.html { render :home, id: @review.id, notice: "Review was successfully created." }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { render :home, id: @review.id, notice: "Review was successfully updated." }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1 or /reviews/1.json
  # DELETE /reviews/1 as JS will remove row from select_modal window
  def destroy
    @review.destroy
    respond_to do |format|
      format.js 
      format.html { redirect_to reviews_url, notice: "Review was successfully destroyed." }
      format.json { head :no_content }
    end
  end

 # home screen for Reviews
 #
 #the home action can be called from either the main navigation bar, in which case review.id will be nil,
 #or after an update or create action, where review.id will not be nil.
  def home
    @review = Review.new if @review.nil?
    #if the call to home is from selecting a previously saved review in the modal window, 
    #then use it and return
    if @review.persisted?
      @new_review = false
      return @review, @new_review
    end
    #otherwise, check if we have a previously saved review and use the most recent as the template for a new review.  
    #This way, the user can have a starter of data and won't overwrite what they already saved.
    #If there is no saved review, fill in some default values.
    @review_templ = Review.where(duser_id: [Duser.system_user,current_duser.id]).last
    if @review_templ.nil?
     @review.duser_id = current_duser.id
     @review.metric_id = DuserMetric.joins(:metric).select(:metric_id).where("metric.series_type": "metric", "duser_metrics.duser_id": current_duser.id).last
     @review.event_id = DuserMetric.joins(:metric).select(:metric_id).where("metric.series_type": "event", "duser_metrics.duser_id": current_duser.id).last
     @review.start_dt = Time.now - 14.days
     @review.end_dt = Time.now 
     @review.significant = false
     @review.span = 24
   else
    @review.assign_attributes(
      id: @review_templ.id,
      duser_id: @review_templ.duser_id,
      metric_id: @review_templ.metric_id,
      event_id: @review_templ.event_id,
      start_dt: @review_templ.start_dt,
      end_dt: @review_templ.end_dt,
      span: @review_templ.span,
      significant: @review_templ.significant
      )
    end
   Rails.logger.info "review:home inspect:  #{@review.inspect}" 
   @new_review = true
   return @review , @new_review
  end

  def get_regression_chart
  end

  # GET /reviews/1 or /reviews/1.json
  # The job of this action is to return a variable to the view that can be
  # evaluated for validations but won't affect the result of the '@review.persisted?' method.
  # The whole idea is to show the 'Save Review' button when the review passes validation,
  # but allow the 'form_with' helper to use the proper route, i.e. model: review for a 
  # new record, or review/:id for a revised record.
  def show_regression
    #byebug 
    # if there is an id in the params, then this is an existing record and we need
    # to modify the attributes without returning a Review.new variable. 
    id = 0
    stat_testname = params.dig(:testname)
    if params.dig(:review)
      id =  params.dig(:review,:id).to_i 
    else
      id =  params.dig(:id).to_i 
    end
    Rails.logger.info "ReviewsController:ShowRegression id: #{id}, params: review-> #{params.dig(:review,:id).to_i} no_review-> #{params.dig(:id)}" 

    #If we already have a saved review, the id will be > 0 and we assign the the possibly
    #changed attributes to the review from the database. Otherwise, create a new review object
    #and assign attributes.
    if id > 0
      @review = Review.find(id)
      @review.assign_attributes(show_regression_params)
    else
       @review = Review.new(show_regression_params)
    end
    Rails.logger.info "after getting parms, review is #{@review.inspect}" 
    Rails.logger.info "after getting parms, review.errors are #{@review.errors}"
  if(@review.validate) 
    begin
    #debugger
    @conn=Rserve::Connection.new
     # TODO - rescue StandardError
     # TODO - rescue_with_handler(StandardError)
    @reviewStats = ReviewStats.new(@review,@conn)
    @reviewStats.perform_analysis(stat_testname)

    #make sure, whatever happens, that the socket connection is closed. Otherwise we'll eventually
    #crash the server.
    ensure
      @conn.close
    end
    Rails.logger.info "stat_classes are #{@reviewStats.stat_classes}" 
  else
    Rails.logger.info "review did not validate, errors are #{@review.errors.full_messages}"
  end
    return @review, @reviewStats

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      id = 0
      if params.dig(:review)
       id =  params.dig(:review,:id).to_i 
      else
       id =  params.dig(:id).to_i 
      end

      @review = Review.find(id) if id > 0
      Rails.logger.info "in: #{params[:controller]} : #{params[:action]} review variable is: #{@review.nil? ? "nil" : true}"
    end
    # Only allow a list of trusted parameters through.
    def review_params
      #Rails.logger.info "review:params before extract! #{params.inspect}"
      params.require(:review).extract!(:created_at,:updated_at)
      params.require(:review).permit(:metric_id, :event_id, :duser_id, :start_dt, :end_dt, :span, :significant,:id)
      #Rails.logger.info "review:params after extract! #{params.inspect}"
    end
    def show_regression_params
      #any call from the form will have the review key
      if(params.has_key?(:review))
       params.require(:review).extract!(:created_at,:updated_at)
       params.require(:review).permit(:metric_id, :event_id, :duser_id, :start_dt, :end_dt, :span, :significant,:id,:testname)
      else
      #any call from the link_to attribute will send attributes only
       params.permit(:metric_id, :event_id, :duser_id, :start_dt, :end_dt, :span, :significant,:id,:testname)
      end
    end

    def show_params
      Rails.logger.info "review:params #{params.inspect}"
    end
end
