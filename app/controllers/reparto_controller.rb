class RepartoController < ApplicationController
	def index
		@ordenes = current_user.repartidor.entregas_pendientes
		render layout: "dataTables"
	end
end
