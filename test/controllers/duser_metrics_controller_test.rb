require 'test_helper'

class DuserMetricsControllerTest < ActionController::TestCase
  setup do
    @duser_metric = duser_metrics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:duser_metrics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create duser_metric" do
    assert_difference('DuserMetric.count') do
      post :create, duser_metric: { duser_id: @duser_metric.duser_id, metric_id: @duser_metric.metric_id, occur_dttm: @duser_metric.occur_dttm, value: @duser_metric.value }
    end

    assert_redirected_to duser_metric_path(assigns(:duser_metric))
  end

  test "should show duser_metric" do
    get :show, id: @duser_metric
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @duser_metric
    assert_response :success
  end

  test "should update duser_metric" do
    patch :update, id: @duser_metric, duser_metric: { duser_id: @duser_metric.duser_id, metric_id: @duser_metric.metric_id, occur_dttm: @duser_metric.occur_dttm, value: @duser_metric.value }
    assert_redirected_to duser_metric_path(assigns(:duser_metric))
  end

  test "should destroy duser_metric" do
    assert_difference('DuserMetric.count', -1) do
      delete :destroy, id: @duser_metric
    end

    assert_redirected_to duser_metrics_path
  end
end
