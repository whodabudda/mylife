require 'test_helper'
#minitest-hooks gem allows the before/after methods
require 'minitest/hooks'

class ActiveSupport::TestCase
  extend MiniTest::Spec::DSL
end

class ActionDispatch::IntegrationTest
  extend MiniTest::Spec::DSL
end

#Minitest.after_run { MetricsControllerTest.after_run }

class MetricsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers 
    include Minitest::Hooks 
  before(:all) do
     @duser = FactoryBot.create(:duser)
     @duser2 = FactoryBot.create(:duser)
     puts "Created 2 Dusers"
  end

  setup do
     sign_in @duser
#     puts "Duser signed in"
  end

  after(:all) do
    Duser.destroy_all
    puts "Executed after(all) cleanup"
  end

  teardown do 
#     puts "teardown executed"
  end

test "should get index of only the users own and system-owned metrics" do
   authrecs = []
   unauthrecs = []
   #
   # create a set of 3 new metrics for each duser, including the system_user, storing resulting Metric
   # object in an array of authorized and unauthorized records.  The objects created for duser2
   # the signed-in duser should not be able to see.
   #
     authrecs.concat(FactoryBot.create_list(:metric,3,duser_id: @duser.id))
     unauthrecs.concat(FactoryBot.create_list(:metric,3,duser_id: @duser2.id))
     authrecs.concat(FactoryBot.create_list(:metric,3,duser_id: 1))
    puts "authrecs: #{authrecs.length}"
    puts "unauthrecs: #{unauthrecs.length}"
    #
    # call the MetricsController#index action
    #
    get metrics_path 
    assert_response :success
    #
    #the ids in the returned metrics should match the ids in the authorized metrics
    assert (assigns(:metrics).map(&:id) - authrecs.map(&:id)).length == 0
    #
    # the ids in the returned metrics should contain none of the ids from the unauthorized metrics
    assert (assigns(:metrics).map(&:id) - unauthrecs.map(&:id)) == assigns(:metrics).map(&:id) 
    assert Metric.all.count == 9
  end

    test "should only create/update metrics that belong to current_duser" do
    #get a non-persisted Metric
    get new_metric_path 
    assert_response :success
    @metric = assigns(:metric)
    #should not yet have an id
    assert @metric.id.nil?
    #duser_id should have been assigned to the current_duser.id in the controller 
    assert_equal @metric.duser_id, @duser.id
    #use the factory to create a Metric with data, and replace the duser_id with the current_duser
    @u = FactoryBot.create(:unit, duser_id: @duser.id)
    assert_difference('Metric.count') do
      post metrics_path, params: { metric:  FactoryBot.attributes_for(:metric,duser_id: @duser.id, unit_id: @u.id )}
    end
    assert_response :redirect

    #change the duser id to one that doesn't own this Metric, and isn't the current_duser.id in the session
    #should fail to create a new Metric
    post metrics_path, params:  { metric:  FactoryBot.attributes_for(:metric,duser_id: 9000, unit_id: @u.id ) }
    #if the flash notice has the word 'access', then an access error was raised
    assert_match  /access/,flash[:notice]
    assert_response :redirect

    #get the last metric we added
    #change the last name by 2 characters and test
    @metric = Metric.last
    assert_difference('Metric.last.name.length',2) do
      patch metric_path(@metric), params: { metric: { name: @metric.name + 'xx' }}
    end

    #finally, try to update the Metric with a changed duser_id. 
    #Should fail with NotAuthorized
    patch metric_path(@metric), params: { metric: { duser_id: 9000, name: 'Newer metric name' }}
    assert_match  /access/,flash[:notice]
    assert_response :redirect
end
test "should not allow a metric name to be changed to an existing metric name" do
    #create a metric
    @metric_1 = FactoryBot.create(:metric, duser_id: @duser.id)
    @metric_2 = FactoryBot.create(:metric, duser_id: @duser.id)
    #update metric_1 name to metric_2's name.  Should fail with record_taken
    begin
      patch metric_path(@metric_1), params: { metric: { name: @metric_2.name }}
    rescue => e
      puts "Actual exception class: #{e.class}"
      raise e
    end
    #get the returned object
    @metric = assigns(:metric)
    #check that error message was returned in the object
    assert_equal ["is already in use"], @metric.errors[:name]
  end

  test "should destroy metric and any DuserMetrics using the metric" do

    #create some DuserMetrics 
    @m = FactoryBot.create(:metric, duser_id: @duser.id)
    @m_2 = FactoryBot.create(:metric, duser_id: @duser.id)
    #duser metrics that won't be destroyed
    FactoryBot.create_list(:duser_metric,2, duser_id: @duser.id, metric_id: @m.id)

    #duser metric that WILL be destroyed
    FactoryBot.create(:duser_metric, duser_id: @duser.id, metric_id: @m_2.id)

    assert_equal DuserMetric.count, 3
    assert_equal Metric.count, 2

    #delete the metric. Should also delete duser_metric using this metric.
    @m_2.destroy
    assert_equal DuserMetric.count, 2
    assert_equal Metric.count, 1
  end 
end
=begin
=end
