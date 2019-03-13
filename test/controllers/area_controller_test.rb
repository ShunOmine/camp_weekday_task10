require 'test_helper'

class AreaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get area_index_url
    assert_response :success
  end

  test "should get search" do
    get area_search_url
    assert_response :success
  end

end
