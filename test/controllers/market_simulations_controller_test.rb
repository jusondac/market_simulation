require "test_helper"

class MarketSimulationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get market_simulations_index_url
    assert_response :success
  end

  test "should get show" do
    get market_simulations_show_url
    assert_response :success
  end

  test "should get new" do
    get market_simulations_new_url
    assert_response :success
  end

  test "should get create" do
    get market_simulations_create_url
    assert_response :success
  end
end
