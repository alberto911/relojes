class HomeController < ApplicationController
	def inicio
		if current_user.is_admin
			set_variables_admin
		elsif current_user.vendedor
			set_variables_vendedor
		elsif current_user.repartidor
			set_variables_repartidor
		end
			
		render layout: "dataTables"
	end

	def set_variables_admin
		@total_ordenes = Orden.suma_total
		@total_pedidos = Pedido.suma_total
		@utilidades_dia = Orden.utilidades_dia
		@utilidades_mes = Orden.utilidades_mes
	end

	def set_variables_vendedor
		@count = Cliente.count_by_vendedor(current_user.vendedor)
		@ventas = Orden.ventas_por_vendedor(current_user.vendedor)
		@ventas_dia = Orden.ventas_dia_vendedor(current_user.vendedor.id)
		@ventas_mes = Orden.ventas_mes_vendedor(current_user.vendedor.id)
		@ventas_cliente = Orden.ventas_cliente_vendedor(current_user.vendedor.id)
	end

	def set_variables_repartidor
		@asignados = Orden.repartos_asignados(current_user.repartidor)
		@completados = Orden.repartos_completados(current_user.repartidor)
		@repartos_dia = Orden.repartos_dia(current_user.repartidor.id)
		@repartos_mes = Orden.repartos_mes(current_user.repartidor.id)
		@repartos_cliente = Orden.repartos_cliente(current_user.repartidor.id)
	end
end
