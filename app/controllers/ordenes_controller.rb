class OrdenesController < ApplicationController
  before_action :ensure_vendedor!, except: [:entregar, :asignar_repartidor, :update_repartidor]
  before_action :ensure_admin!, only: [:asignar_repartidor, :update_repartidor]
  before_action :ensure_repartidor!, only: :entregar
  before_action :validar_permisos, only: [:show, :edit, :update, :destroy, :place]
	before_action :ensure_not_placed, only: [:edit, :update, :destroy]
  before_action :set_vendedor, only: [:index, :new, :edit]
  before_action :set_orden, only: [:asignar_repartidor, :update_repartidor, :entregar]

  # GET /ordenes
  # GET /ordenes.json
  def index
    @ordenes = @vendedor ? Orden.por_vendedor(@vendedor.id) : Orden.all

	respond_to do |format|
		format.html { render layout: "dataTables" }
		format.pdf do
			render pdf: 'ordenes',                  # file name
			layout: 'layouts/application.pdf.erb',  # layout used
			show_as_html: params[:debug].present?    # allow debuging
		end
    end
  end

  def stats
	respond_to do |format|
		format.html { render layout: "dataTables" }
		format.pdf do
			render pdf: 'ordenes',                 # file name
			layout: 'layouts/application.pdf.erb',  # layout used
			show_as_html: params[:debug].present?    # allow debuging
		end
    end
  end

  # GET /ordenes/1
  # GET /ordenes/1.json
  def show
	@ordenes_cantidades = @orden.ordenes_cantidades
	render layout: "dataTables"
  end

  # GET /ordenes/new
  def new
    @orden = Orden.new
		set_options_for_selects(@vendedor)
  end

  # GET /ordenes/1/edit
  def edit
		set_options_for_selects(@vendedor)
  end

  # POST /ordenes
  # POST /ordenes.json
  def create
    @orden = Orden.new(orden_params)

    respond_to do |format|
      if current_user.tiene_permiso_sobre?(@orden) && @orden.save
        format.html { redirect_to @orden, notice: 'La orden se creó exitosamente.' }
        format.json { render :show, status: :created, location: @orden }
      else
        format.html { render :new }
        format.json { render json: @orden.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ordenes/1
  # PATCH/PUT /ordenes/1.json
  def update
    respond_to do |format|
      if @orden.update(orden_params)
        format.html { redirect_to @orden, notice: 'La orden se actualizó exitosamente.' }
        format.json { render :show, status: :ok, location: @orden }
      else
        format.html { render :edit }
        format.json { render json: @orden.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ordenes/1
  # DELETE /ordenes/1.json
  def destroy
		@orden.destroy
	  respond_to do |format|
	    format.html { redirect_to ordenes_url, notice: 'La orden se borró exitosamente.' }
	    format.json { head :no_content }
	  end
  end

	def update_tiendas
		cliente = Cliente.find(params[:cliente_id])
		@tiendas_clientes = cliente.tiendas_clientes.map{|t| [t.nombre, t.id]}.insert(0, "Selecciona una tienda")
	end

  def place
		unless @orden.ordenes_cantidades.empty?
			@orden.update(total: @orden.total)
			@orden.update(fecha_pedido: Time.now)
			redirect_to @orden, notice: 'La orden fue completada exitosamente.'
		else
			redirect_to @orden, alert: 'No hay productos en la orden.'
		end
	end

	def asignar_repartidor
		if @orden.fecha_pedido && !@orden.entregada?
			@repartidores = Repartidor.all
		else
			redirect_to ordenes_url, alert: 'No puedes asignar esta orden a un repartidor.'
		end
  end

	def update_repartidor
		permitted = params.require(:orden).permit(:repartidor_id)
		if permitted[:repartidor_id].nil?
			redirect_to :asignar_repartidor, alert: 'El repartidor no puede estar vacío.'
		elsif @orden.fecha_pedido && !@orden.entregada?
      @orden.update(permitted)
			redirect_to @orden, notice: 'El repartidor se asignó exitosamente.'
		end
	end

	def entregar
		if !current_user.is_admin
			if @orden.repartidor != current_user.repartidor
				redirect_to reparto_path, alert: 'No puedes entregar una orden que no te hayan asignado.'
			else
				@orden.update(fecha_entrega: Time.now)
				redirect_to reparto_path, notice: 'La orden se marcó como entregada.'
			end
		elsif @orden.fecha_pedido && @orden.repartidor
			@orden.update(fecha_entrega: Time.now)
			redirect_to ordenes_url, notice: 'La orden se marcó como entregada.'
		else
			redirect_to ordenes_url, alert: 'La orden no ha sido completada.'
		end
	end

  private
		def set_options_for_selects(vendedor)
			if vendedor
				@clientes = Cliente.con_tiendas.where(vendedor_id: vendedor.id)
				@tiendas_clientes = TiendaCliente.por_vendedor(vendedor.id)
			else
				@clientes = Cliente.con_tiendas
				@tiendas_clientes = TiendaCliente.all
			end
		end

		def validar_permisos
			set_orden
			unless current_user.tiene_permiso_sobre? @orden
				redirect_to ordenes_url, alert: 'No tienes los permisos necesarios.'
			end
		end

		def ensure_not_placed
			set_orden
			if @orden.fecha_pedido
				redirect_to orden_url(@orden), alert: 'No se puede alterar una orden que ya ha sido completada.'
			end
		end

		# Use callbacks to share common setup or constraints between actions.
    def set_orden
      @orden = Orden.find(params[:id])
    end

    def set_vendedor
			@vendedor = current_user.vendedor
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def orden_params
      params.require(:orden).permit(:fecha_entrega, :tienda_cliente_id, :repartidor_id)
    end
end
