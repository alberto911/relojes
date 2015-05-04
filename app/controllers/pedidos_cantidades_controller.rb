class PedidosCantidadesController < ApplicationController
  before_action :ensure_admin!
  before_action :set_pedido_cantidad, only: [:edit, :update, :destroy]
  before_action :set_pedido
  before_action :ensure_not_placed, only: [:new, :create, :edit, :update, :destroy]
  respond_to :html, :js

  # GET /pedidos_cantidades
  # GET /pedidos_cantidades.json
  def index
    @pedidos_cantidades = @pedido.pedidos_cantidades
		render layout: "dataTables"
  end

  # GET /pedidos_cantidades/new
  def new
    @pedido_cantidad = @pedido.pedidos_cantidades.build
		@relojes = @pedido.proveedor.relojes
  end

  # GET /pedidos_cantidades/1/edit
  def edit
		@relojes = @pedido.proveedor.relojes
  end

  # POST /pedidos_cantidades
  # POST /pedidos_cantidades.json
  def create
		@pedidos_cantidades = @pedido.pedidos_cantidades
    @pedido_cantidad = @pedidos_cantidades.create(pedido_cantidad_params)

    respond_to do |format|
      if @pedido_cantidad.save
        format.html { redirect_to @pedido, notice: 'El producto se agregó exitosamente.' }
				format.js
      else
        format.html { render :new }
        format.js
      end
    end
  end

  # PATCH/PUT /pedidos_cantidades/1
  # PATCH/PUT /pedidos_cantidades/1.json
  def update
		@pedidos_cantidades = @pedido.pedidos_cantidades
		@pedido_cantidad.update_attributes(update_params)

    respond_to do |format|
      if @pedido_cantidad.update(update_params)
        format.html { redirect_to @pedido, notice: 'El producto se actualizó exitosamente.' }
        format.js
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  # DELETE /pedidos_cantidades/1
  # DELETE /pedidos_cantidades/1.json
  def destroy
		@pedidos_cantidades = @pedido.pedidos_cantidades
    @pedido_cantidad.destroy
    respond_to do |format|
      format.html { redirect_to @pedido, notice: 'El producto se borró exitosamente.' }
			format.js
    end
  end

  private
		def ensure_not_placed
			if @pedido.fecha_pedido
				redirect_to pedido_url(@pedido), alert: 'No se puede alterar un pedido que ya ha sido completado.'
			end
		end 
		
		# Use callbacks to share common setup or constraints between actions.
    def set_pedido_cantidad
      @pedido_cantidad = PedidoCantidad.find(params[:id])
    end

		def set_pedido
			@pedido = Pedido.find(params[:pedido_id])
		end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pedido_cantidad_params
      params.require(:pedido_cantidad).permit(:cantidad, :reloj_id)
    end

		def update_params
      params.require(:pedido_cantidad).permit(:cantidad)
    end
end
