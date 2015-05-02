class Orden < ActiveRecord::Base
	belongs_to :tienda_cliente, inverse_of: :ordenes
	belongs_to :repartidor, inverse_of: :ordenes
	has_many :ordenes_cantidades, dependent: :destroy
	has_many :relojes, through: :ordenes_cantidades

	validates :tienda_cliente_id, presence: true

	def self.por_vendedor(vendedor_id)
		Orden.joins("JOIN tiendas_clientes tc ON tc.id = ordenes.tienda_cliente_id JOIN clientes c ON c.id = tc.cliente_id").where("c.vendedor_id = ?", vendedor_id)
	end

  def vendedor
		tienda_cliente.cliente.vendedor
  end

	def total
	  	total = 0
		ordenes_cantidades.each do |oc|
			total += oc.subtotal
		end
		total
	end

	def entregada?
		!fecha_entrega.nil?
  end

	def tiene_repartidor?
		!repartidor.nil?
	end
	
	def self.utilidades_dia
		utilidades = self.ventas_dia
		compras = Pedido.compras_dia
		compras.map do |c|
			utilidades.has_key?(c.first) ? utilidades[c.first] -= c.second : utilidades[c.first] = -c.second
		end
		utilidades				
	end	

	def self.utilidades_mes
		utilidades = self.ventas_mes
		compras = Pedido.compras_mes
		compras.map do |c|
			utilidades.has_key?(c.first) ? utilidades[c.first] -= c.second : utilidades[c.first] = -c.second
		end
		utilidades				
	end	

	def self.ventas_dia
		select("total").group_by_day(:fecha_pedido, last: 30).sum("total")
	end

	def self.ventas_mes
		select("total").group_by_month(:fecha_pedido, last: 12).sum("total")
	end
	
	def self.ventas_proveedor
		data = {}
		final = {}
		OrdenCantidad.all.map do |oc|
			proveedor = oc.reloj.proveedor.id
			data.has_key?(proveedor) ? data[proveedor] += oc.subtotal : data[proveedor] = oc.subtotal
		end
		data.map do |d|
			final[Proveedor.find(d.first).nombre] = d.second
		end
		final
	end

	def self.ventas_vendedor
		data = {}
		final = {}
		Orden.all.map do |o|
			vendedor = o.tienda_cliente.cliente.vendedor.id
			data.has_key?(vendedor) ? data[vendedor] += o.total : data[vendedor] = o.total				
		end
		data.map do |d|
			final[Vendedor.find(d.first).nombre] = d.second
		end
		final
	end

	def self.ventas_cliente
		joins("join tiendas_clientes tc on ordenes.tienda_cliente_id = tc.id join clientes c on tc.cliente_id = c.id ").group("c.nombre").sum("total")
	end

	def self.ventas_dia_vendedor(u)
		joins("join tiendas_clientes tc on ordenes.tienda_cliente_id = tc.id join clientes c on tc.cliente_id = c.id ").where("c.vendedor_id = ?", u).group_by_day(:fecha_pedido, last: 30).sum("total")
	end

	def self.ventas_mes_vendedor(u)
		joins("join tiendas_clientes tc on ordenes.tienda_cliente_id = tc.id join clientes c on tc.cliente_id = c.id ").where("c.vendedor_id = ?", u).group_by_month(:fecha_pedido, last: 12).sum("total")
	end

	def self.ventas_cliente_vendedor(u)
		joins("join tiendas_clientes tc on ordenes.tienda_cliente_id = tc.id join clientes c on tc.cliente_id = c.id ").where("c.vendedor_id = ?", u).group("c.nombre").sum("total")
	end

	def self.repartos_dia(u)
		where("ordenes.fecha_entrega IS NOT NULL AND repartidor_id = ?", u).group_by_day(:fecha_entrega, format: "%d-%m-%y", last: 30).count
	end

	def self.repartos_mes(u)
		where("ordenes.fecha_entrega IS NOT NULL AND repartidor_id = ?", u).group_by_month(:fecha_entrega, format: "%m-%y", last: 12).count
	end

	def self.repartos_cliente(u)
		joins("join tiendas_clientes tc on ordenes.tienda_cliente_id = tc.id join clientes c on tc.cliente_id = c.id ").where("ordenes.fecha_entrega IS NOT NULL AND repartidor_id = ?", u).group("c.nombre").count
	end
end
