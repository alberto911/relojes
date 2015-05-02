class VendedoresController < ApplicationController
  before_action :ensure_admin!
  before_action :set_vendedor, only: [:show, :edit, :update, :destroy]

  # GET /vendedores
  # GET /vendedores.json
  def index
    @vendedores = Vendedor.all
		render layout: "dataTables"
  end

  # GET /vendedores/1
  # GET /vendedores/1.json
  def show
  end

  # GET /vendedores/new
  def new
    @vendedor = Vendedor.new
  end

  # GET /vendedores/1/edit
  def edit
  end

  # POST /vendedores
  # POST /vendedores.json
  def create
    user = User.new(user_params)
		@vendedor = Vendedor.new(vendedor_params)

		unless @vendedor.valid?
			render :new
		else
			if user.save
		    @vendedor.user_id = user.id
				  if @vendedor.save
				    redirect_to @vendedor, notice: 'El vendedor se creó exitosamente.'
				  else
				    render :new
				  end
			else
				flash[:alert] = user.errors.full_messages.first
				render :new
			end
		end
  end

  # PATCH/PUT /vendedores/1
  # PATCH/PUT /vendedores/1.json
  def update
		user = User.find(@vendedor.user_id)
    if @vendedor.update(vendedor_params) && user.update(user_params)
			sign_in(current_user, :bypass => true)
      redirect_to @vendedor, notice: 'El vendedor se actualizó exitosamente.'
    else
			flash[:alert] = user.errors.full_messages.first
      render :edit
    end
  end

  # DELETE /vendedores/1
  # DELETE /vendedores/1.json
  def destroy
		if @vendedor.destroy
    	redirect_to vendedores_url, notice: 'El vendedor se borró exitosamente.'
		else
			flash[:alert] = @vendedor.errors.full_messages.first
			redirect_to :action => :index
		end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vendedor
      @vendedor = Vendedor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vendedor_params
      params.require(:vendedor).permit(:nombre, :telefono, :rfc)
    end

		def user_params
			if params[:user][:password].present?			
				params.require(:user).permit(:email, :password)
			else
				params.require(:user).permit(:email)
			end
		end
end
