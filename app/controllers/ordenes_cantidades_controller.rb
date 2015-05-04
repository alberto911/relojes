class OrdenesCantidadesController < ApplicationController
  before_action :ensure_vendedor!
  before_action :validar_permisos, except: :update_relojes
  before_action :ensure_not_placed, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_orden_cantidad, only: [:edit, :update, :destroy]
  respond_to :html, :js

  # GET /ordenes_cantidades/new
  def new
    @orden_cantidad = @orden.ordenes_cantidades.build
		set_options_for_selects
  end

  # GET /ordenes_cantidades/1/edit
  def edit
		set_options_for_selects
  end

  # POST /ordenes_cantidades
  # POST /ordenes_cantidades.json
  def create
		@ordenes_cantidades = @orden.ordenes_cantidades
    @orden_cantidad = @ordenes_cantidades.create(orden_cantidad_params)

    respond_to do |format|
      if @orden_cantidad.save
        format.html { redirect_to @orden, notice: 'El producto se agregó exitosamente.' }
				format.js
      else
        format.html { render :new }
        format.js
      end
    end
  end

  # PATCH/PUT /ordenes_cantidades/1
  # PATCH/PUT /ordenes_cantidades/1.json
  def update
		@ordenes_cantidades = @orden.ordenes_cantidades
		@orden_cantidad.update_attributes(update_params)

    respond_to do |format|
      if @orden_cantidad.update(update_params)
        format.html { redirect_to @orden, notice: 'El producto se actualizó exitosamente.' }
        format.js
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  # DELETE /ordenes_cantidades/1
  # DELETE /ordenes_cantidades/1.json
  def destroy
		@ordenes_cantidades = @orden.ordenes_cantidades
    @orden_cantidad.destroy
    respond_to do |format|
      format.html { redirect_to @orden, notice: 'El producto se borró exitosamente.' }
			format.js
    end
  end

	def update_relojes
		proveedor = Proveedor.find(params[:proveedor_id])
		@relojes = proveedor.relojes.map{|r| [r.modelo, r.id]}.insert(0, "Selecciona un reloj")
  end

  private
		def validar_permisos
			@orden = Orden.find(params[:orden_id])
			unless current_user.tiene_permiso_sobre? @orden
				redirect_to ordenes_url, alert: 'No tienes los permisos necesarios.'
			end
		end

		def ensure_not_placed
			@orden = Orden.find(params[:orden_id])
			if @orden.fecha_pedido
				redirect_to orden_url(@orden), alert: 'No se puede alterar una orden que ya ha sido completada.'
			end
		end

		def set_options_for_selects
			@proveedores = Proveedor.con_relojes
			@relojes = Reloj.all
		end
		
    # Use callbacks to share common setup or constraints between actions.
    def set_orden_cantidad
      @orden_cantidad = OrdenCantidad.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def orden_cantidad_params
      params.require(:orden_cantidad).permit(:cantidad, :reloj_id)
    end

		def update_params
			params.require(:orden_cantidad).permit(:cantidad)
		end
end
