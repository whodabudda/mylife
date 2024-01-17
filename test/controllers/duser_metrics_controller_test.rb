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
class DuserMetricsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers 
  include Minitest::Hooks 
  before(:all) do
    @duser = FactoryBot.create(:duser)
    @duser2 = FactoryBot.create(:duser)
    @m = FactoryBot.create(:metric , duser_id: @duser.id)
    @m_2 = FactoryBot.create(:metric , duser_id: @duser2.id)
    puts "Created 2 Dusers and 2 Metrics"
  end
  setup do
    sign_in @duser
  end

  after(:all) do
    Duser.destroy_all
    puts "Executed after(all) cleanup"
  end

 test "should get index of only the users own and system-owned metrics" do
   authrecs = []
   unauthrecs = []
   #
   # create a set of 3 new duser_metrics for each duser, including the system_user, storing resulting duser_Metric
   # object in an array of authorized and unauthorized records.  The objects created for duser2
   # the signed-in duser should not be able to see.
   #
    authrecs.concat(FactoryBot.create_list(:duser_metric,3 , duser_id: @duser.id, metric_id: @m.id))
    unauthrecs.concat(FactoryBot.create_list(:duser_metric,3 , duser_id: @duser2.id, metric_id: @m_2.id))
    puts "authrecs: #{authrecs.length}"
    puts "unauthrecs: #{unauthrecs.length}"
    #
    # call the MetricsController#index action
    #
    get duser_metrics_path 
    assert_response :success
    #
    #the ids in the returned duser_metrics should match the ids in the authorized duser_metrics
    assert (assigns(:duser_metrics).map(&:id) - authrecs.map(&:id)).length == 0
    #
    # the ids in the returned duser_metrics should contain none of the ids from the unauthorized duser_metrics
    assert (assigns(:duser_metrics).map(&:id) - unauthrecs.map(&:id)) == assigns(:duser_metrics).map(&:id) 
    assert DuserMetric.all.count == 6
  end

 test "should should allow only numeric value for metric or event" do
   @duser_metric = FactoryBot.create(:duser_metric, duser_id: @duser.id, metric_id: @m.id)
   @duser_metric = patch duser_metric_path(@duser_metric), params: { duser_metric: { value: 'imastring' }}
   @duser_metric.save
   assert_equal ["must be numeric"], @duser_metric.errors[:value]
  end
end
=begin
=end
