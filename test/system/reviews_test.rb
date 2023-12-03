require "application_system_test_case"

class ReviewsTest < ApplicationSystemTestCase
  setup do
    @review = reviews(:one)
  end

  test "visiting the index" do
    visit reviews_url
    assert_selector "h1", text: "Reviews"
  end

  test "creating a Review" do
    visit reviews_url
    click_on "New Review"

    fill_in "End dt", with: @review.end_dt
    fill_in "Event", with: @review.event_id
    fill_in "Metric id", with: @review.metric_id_id
    check "Significant" if @review.significant
    fill_in "Span", with: @review.span
    fill_in "Start dt", with: @review.start_dt
    fill_in "User id", with: @review.user_id_id
    click_on "Create Review"

    assert_text "Review was successfully created"
    click_on "Back"
  end

  test "updating a Review" do
    visit reviews_url
    click_on "Edit", match: :first

    fill_in "End dt", with: @review.end_dt
    fill_in "Event", with: @review.event_id
    fill_in "Metric id", with: @review.metric_id_id
    check "Significant" if @review.significant
    fill_in "Span", with: @review.span
    fill_in "Start dt", with: @review.start_dt
    fill_in "User id", with: @review.user_id_id
    click_on "Update Review"

    assert_text "Review was successfully updated"
    click_on "Back"
  end

  test "destroying a Review" do
    visit reviews_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Review was successfully destroyed"
  end
end
