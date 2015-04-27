require 'test_helper'

class RelojesControllerTest < ActionController::TestCase
  setup do
    @reloj = relojes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:relojes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reloj" do
    assert_difference('Reloj.count') do
      post :create, reloj: { descripcion: @reloj.descripcion, marca: @reloj.marca, modelo: @reloj.modelo, precio: @reloj.precio }
    end

    assert_redirected_to reloj_path(assigns(:reloj))
  end

  test "should show reloj" do
    get :show, id: @reloj
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @reloj
    assert_response :success
  end

  test "should update reloj" do
    patch :update, id: @reloj, reloj: { descripcion: @reloj.descripcion, marca: @reloj.marca, modelo: @reloj.modelo, precio: @reloj.precio }
    assert_redirected_to reloj_path(assigns(:reloj))
  end

  test "should destroy reloj" do
    assert_difference('Reloj.count', -1) do
      delete :destroy, id: @reloj
    end

    assert_redirected_to relojes_path
  end
end
