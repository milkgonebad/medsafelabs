require 'test_helper'

class StrainsControllerTest < ActionController::TestCase
  setup do
    @strain = strains(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:strains)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create strain" do
    assert_difference('Strain.count') do
      post :create, strain: { name: @strain.name }
    end

    assert_redirected_to strain_path(assigns(:strain))
  end

  test "should show strain" do
    get :show, id: @strain
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @strain
    assert_response :success
  end

  test "should update strain" do
    patch :update, id: @strain, strain: { name: @strain.name }
    assert_redirected_to strain_path(assigns(:strain))
  end

  test "should destroy strain" do
    assert_difference('Strain.count', -1) do
      delete :destroy, id: @strain
    end

    assert_redirected_to strains_path
  end
end
