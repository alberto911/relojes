class ProveedoresController < ApplicationController
  before_action :ensure_admin!
  before_action :set_proveedor, only: [:show, :edit, :update, :destroy]

  # GET /proveedores
  # GET /proveedores.json
  def index
    @proveedores = Proveedor.all
		respond_to do |format|
      format.html { render layout: "dataTables" }
			format.csv { send_data @proveedores.to_csv }
    end
  end

  # GET /proveedores/1
  # GET /proveedores/1.json
  def show
  end

  # GET /proveedores/new
  def new
    @proveedor = Proveedor.new
  end

  # GET /proveedores/1/edit
  def edit
  end

  # POST /proveedores
  # POST /proveedores.json
  def create
    @proveedor = Proveedor.new(proveedor_params)

    respond_to do |format|
      if @proveedor.save
        format.html { redirect_to @proveedor, notice: 'El proveedor se creó exitosamente.' }
        format.json { render :show, status: :created, location: @proveedor }
      else
        format.html { render :new }
        format.json { render json: @proveedor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proveedores/1
  # PATCH/PUT /proveedores/1.json
  def update
    respond_to do |format|
      if @proveedor.update(proveedor_params)
        format.html { redirect_to @proveedor, notice: 'El proveedor se actualizó exitosamente.' }
        format.json { render :show, status: :ok, location: @proveedor }
      else
        format.html { render :edit }
        format.json { render json: @proveedor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proveedores/1
  # DELETE /proveedores/1.json
  def destroy
		if @proveedor.pedidos.empty?    
			@proveedor.destroy
  		redirect_to proveedores_url, notice: 'El proveedor se borró exitosamente.'
    else
			@proveedor.update(activo: false)
			@proveedor.relojes.update_all("activo = false")
			redirect_to proveedores_url, notice: 'El proveedor se ha desactivado.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proveedor
      @proveedor = Proveedor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proveedor_params
      params.require(:proveedor).permit(:nombre, :telefono, :direccion, :rfc)
    end
end
