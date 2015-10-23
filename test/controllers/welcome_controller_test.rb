require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get greeting" do
    get :greeting
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get doc" do
    get :doc
    assert_response :success
  end

end
