require 'test_helper'

class UserSessionControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get add_metric" do
    get :add_metric
    assert_response :success
  end

  test "should get add_event" do
    get :add_event
    assert_response :success
  end

  test "should get define_metric" do
    get :define_metric
    assert_response :success
  end

  test "should get define_event" do
    get :define_event
    assert_response :success
  end

  test "should get refresh" do
    get :refresh
    assert_response :success
  end

end
