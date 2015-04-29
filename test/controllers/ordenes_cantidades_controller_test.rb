require 'test_helper'

class OrdenesCantidadesControllerTest < ActionController::TestCase
  setup do
    @orden_cantidad = ordenes_cantidades(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ordenes_cantidades)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create orden_cantidad" do
    assert_difference('OrdenCantidad.count') do
      post :create, orden_cantidad: { cantidad: @orden_cantidad.cantidad }
    end

    assert_redirected_to orden_cantidad_path(assigns(:orden_cantidad))
  end

  test "should show orden_cantidad" do
    get :show, id: @orden_cantidad
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @orden_cantidad
    assert_response :success
  end

  test "should update orden_cantidad" do
    patch :update, id: @orden_cantidad, orden_cantidad: { cantidad: @orden_cantidad.cantidad }
    assert_redirected_to orden_cantidad_path(assigns(:orden_cantidad))
  end

  test "should destroy orden_cantidad" do
    assert_difference('OrdenCantidad.count', -1) do
      delete :destroy, id: @orden_cantidad
    end

    assert_redirected_to ordenes_cantidades_path
  end
end
