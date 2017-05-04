require 'test_helper'

class MentorsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mentors_index_url
    assert_response :success
  end

  test "should get show" do
    get mentors_show_url
    assert_response :success
  end

  test "should get create" do
    get mentors_create_url
    assert_response :success
  end

  test "should get update" do
    get mentors_update_url
    assert_response :success
  end

  test "should get destroy" do
    get mentors_destroy_url
    assert_response :success
  end

end
