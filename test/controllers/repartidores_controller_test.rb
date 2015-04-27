require 'test_helper'

class RepartidoresControllerTest < ActionController::TestCase
  setup do
    @repartidor = repartidores(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:repartidores)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create repartidor" do
    assert_difference('Repartidor.count') do
      post :create, repartidor: { direccion: @repartidor.direccion, nombre: @repartidor.nombre, rfc: @repartidor.rfc, telefono: @repartidor.telefono }
    end

    assert_redirected_to repartidor_path(assigns(:repartidor))
  end

  test "should show repartidor" do
    get :show, id: @repartidor
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @repartidor
    assert_response :success
  end

  test "should update repartidor" do
    patch :update, id: @repartidor, repartidor: { direccion: @repartidor.direccion, nombre: @repartidor.nombre, rfc: @repartidor.rfc, telefono: @repartidor.telefono }
    assert_redirected_to repartidor_path(assigns(:repartidor))
  end

  test "should destroy repartidor" do
    assert_difference('Repartidor.count', -1) do
      delete :destroy, id: @repartidor
    end

    assert_redirected_to repartidores_path
  end
end
