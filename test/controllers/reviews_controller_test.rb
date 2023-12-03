require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @review = reviews(:one)
  end

  test "should get index" do
    get reviews_url
    assert_response :success
  end

  test "should get new" do
    get new_review_url
    assert_response :success
  end

  test "should create review" do
    assert_difference('Review.count') do
      post reviews_url, params: { review: { end_dt: @review.end_dt, event_id: @review.event_id, metric_id_id: @review.metric_id_id, significant: @review.significant, span: @review.span, start_dt: @review.start_dt, user_id_id: @review.user_id_id } }
    end

    assert_redirected_to review_url(Review.last)
  end

  test "should show review" do
    get review_url(@review)
    assert_response :success
  end

  test "should get edit" do
    get edit_review_url(@review)
    assert_response :success
  end

  test "should update review" do
    patch review_url(@review), params: { review: { end_dt: @review.end_dt, event_id: @review.event_id, metric_id_id: @review.metric_id_id, significant: @review.significant, span: @review.span, start_dt: @review.start_dt, user_id_id: @review.user_id_id } }
    assert_redirected_to review_url(@review)
  end

  test "should destroy review" do
    assert_difference('Review.count', -1) do
      delete review_url(@review)
    end

    assert_redirected_to reviews_url
  end
end
