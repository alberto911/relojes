class PedidosController < ApplicationController
  before_action :ensure_admin!
  before_action :set_pedido, only: [:show, :edit, :update, :destroy, :recibir, :place]

  # GET /pedidos
  # GET /pedidos.json
  def index
    @pedidos = Pedido.all
		render layout: "dataTables"
  end
  
  def stats
		render layout: "dataTables"
  end

  # GET /pedidos/1
  # GET /pedidos/1.json
  def show
		@pedidos_cantidades = @pedido.pedidos_cantidades
		render layout: "dataTables"
  end

  # GET /pedidos/new
  def new
    @pedido = Pedido.new
		@proveedores = Proveedor.joins(:relojes).distinct.order('nombre asc')
  end

  # POST /pedidos
  # POST /pedidos.json
  def create
    @pedido = Pedido.new(pedido_params)

    respond_to do |format|
      if @pedido.save
        format.html { redirect_to @pedido, notice: 'El pedido se creó exitosamente.' }
        format.json { render :show, status: :created, location: @pedido }
      else
        format.html { render :new }
        format.json { render json: @pedido.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pedidos/1
  # DELETE /pedidos/1.json
  def destroy
		unless @pedido.fecha_pedido    
			@pedido.destroy
		  respond_to do |format|
		    format.html { redirect_to pedidos_url, notice: 'El pedido se borró exitosamente.' }
		    format.json { head :no_content }
		  end
		else		
			redirect_to :back, alert: 'No se puede borrar un pedido que ya ha sido enviado.'
    end
  end

	def place
		unless @pedido.pedidos_cantidades.empty?
			@pedido.update(total: @pedido.total)
			@pedido.update(fecha_pedido: Time.now)
			redirect_to @pedido, notice: 'El pedido fue completado exitosamente.'
		else
			redirect_to @pedido, alert: 'No hay productos en el pedido.'
		end
	end

  def recibir
		if @pedido.fecha_pedido
			@pedido.transaction do
				@pedido.update(fecha_entrega: Time.now)
				cantidades = @pedido.pedidos_cantidades
				@pedido.relojes.each do |reloj|
					reloj.stock += cantidades.where(reloj_id: reloj.id).first.cantidad
					reloj.save
				end
			end
			redirect_to :back, notice: 'El pedido fue recibido exitosamente.'
		else
			redirect_to pedidos_url, alert: 'El pedido no ha sido completado.'
		end
	end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pedido
      @pedido = Pedido.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pedido_params
      params.require(:pedido).permit(:fecha_entrega, :proveedor_id)
    end
end
