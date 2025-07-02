require "test_helper"

class PackagingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get packagings_index_url
    assert_response :success
  end

  test "should get show" do
    get packagings_show_url
    assert_response :success
  end

  test "should get new" do
    get packagings_new_url
    assert_response :success
  end

  test "should get create" do
    get packagings_create_url
    assert_response :success
  end

  test "should get edit" do
    get packagings_edit_url
    assert_response :success
  end

  test "should get update" do
    get packagings_update_url
    assert_response :success
  end

  test "should get destroy" do
    get packagings_destroy_url
    assert_response :success
  end
end
