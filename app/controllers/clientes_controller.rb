class ClientesController < ApplicationController
  before_action :ensure_admin!, except: [:index, :show]
	before_action :ensure_vendedor!, only: [:index, :show]
  before_action :set_cliente, only: [:show, :edit, :update, :destroy]

  # GET /clientes
  # GET /clientes.json
  def index
    @clientes = current_user.vendedor ? current_user.vendedor.clientes : Cliente.all

		respond_to do |format|
      format.html { render layout: "dataTables" }
			format.csv { send_data @clientes.to_csv }
    end
  end

  # GET /clientes/1
  # GET /clientes/1.json
  def show
		unless current_user.tiene_permiso_sobre? @cliente
			redirect_to clientes_url, alert: 'No tienes los permisos necesarios para ver ese cliente.'
		end
  end

  # GET /clientes/new
  def new
    @cliente = Cliente.new
  end

  # GET /clientes/1/edit
  def edit
  end

  # POST /clientes
  # POST /clientes.json
  def create
    @cliente = Cliente.new(cliente_params)

    respond_to do |format|
      if @cliente.save
        format.html { redirect_to @cliente, notice: 'El cliente se creó exitosamente.' }
        format.json { render :show, status: :created, location: @cliente }
      else
        format.html { render :new }
        format.json { render json: @cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clientes/1
  # PATCH/PUT /clientes/1.json
  def update
    respond_to do |format|
			@cliente.attributes = cliente_params
			if @cliente.vendedor_id_changed?
				@cliente.fecha_asignacion = Time.now
			end
      if @cliente.save
        format.html { redirect_to @cliente, notice: 'El cliente se actualizó exitosamente.' }
        format.json { render :show, status: :ok, location: @cliente }
      else
        format.html { render :edit }
        format.json { render json: @cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clientes/1
  # DELETE /clientes/1.json
  def destroy
		if Orden.por_cliente(@cliente).empty?
    	@cliente.destroy
      redirect_to clientes_url, notice: 'El cliente se borró exitosamente.'
    else
			@cliente.update(activo: false)
			@cliente.tiendas_clientes.update_all("activo = false")
			redirect_to clientes_url, notice: 'El cliente se ha desactivado.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cliente
      @cliente = Cliente.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cliente_params
      params.require(:cliente).permit(:nombre, :telefono, :direccion_fiscal, :rfc, :vendedor_id)
    end
end
