class Orden < ActiveRecord::Base
	belongs_to :tienda_cliente, inverse_of: :ordenes
	belongs_to :repartidor, inverse_of: :ordenes
	has_many :ordenes_cantidades, dependent: :destroy
	has_many :relojes, through: :ordenes_cantidades

	validates :tienda_cliente_id, presence: true

	def self.to_csv
		CSV.generate do |csv|
		  csv << ['id', 'cliente', 'tienda', 'fecha_pedido', 'fecha_entrega', 'repartidor', 'total']
		  all.each do |orden|
				valores = [orden.id, orden.tienda_cliente.cliente.nombre, orden.tienda_cliente.nombre, orden.fecha_pedido, orden.fecha_entrega]
				orden.repartidor ? valores.push(orden.repartidor.nombre) : valores.push(nil)
		    valores.push(orden.total)
				csv << valores
		  end
  	end
	end

	def self.suma_total
		self.sum("total")
	end

	def self.repartos_asignados(repartidor)
		self.where("repartidor_id = ?", repartidor.id).count
	end

	def self.repartos_completados(repartidor)
		self.where("ordenes.fecha_entrega IS NOT NULL AND repartidor_id = ?", repartidor.id).count
	end

	def tienda_cliente
		TiendaCliente.unscoped.where(id: tienda_cliente_id).first
	end

	def self.ventas_por_vendedor(vendedor)
    self.joins("join tiendas_clientes tc on ordenes.tienda_cliente_id = tc.id join clientes c on tc.cliente_id = c.id ").where("c.vendedor_id = ?", vendedor.id).sum("total")
	end

	def self.por_entregar(repartidor_id)
		self.where("fecha_entrega IS NULL AND repartidor_id = ?", repartidor_id).map do |orden|
			orden.tienda_cliente.direccion
		end
  end

	def self.por_repartidor
		tiendas = []		
		self.where("fecha_entrega IS NULL AND repartidor_id IS NOT NULL").map do |orden|
			h = {}			
			h[:id] = orden.repartidor_id
			h[:direccion] =  orden.tienda_cliente.direccion
			tiendas.push(h)
		end
		tiendas
	end

	def self.por_cliente(cliente)
		self.where("tienda_cliente_id IN (?)", cliente.tiendas_unscoped.select(:id))
	end

	def self.por_vendedor(vendedor_id)
		Orden.joins("JOIN tiendas_clientes tc ON tc.id = ordenes.tienda_cliente_id JOIN clientes c ON c.id = tc.cliente_id").where("c.vendedor_id = ?", vendedor_id)
	end

  def vendedor
		tienda_cliente.cliente.vendedor
  end

	def total
		if fecha_pedido
			read_attribute(:total)
		else	  
			total = 0
			ordenes_cantidades.each do |oc|
				total += oc.subtotal
			end
			total
		end
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
		Orden.where("fecha_pedido IS NOT NULL").map do |o|
			if o.fecha_pedido >= o.tienda_cliente.cliente.fecha_asignacion
				vendedor = o.tienda_cliente.cliente.vendedor.id
				data.has_key?(vendedor) ? data[vendedor] += o.total : data[vendedor] = o.total
			end				
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
			joins("join tiendas_clientes tc on ordenes.tienda_cliente_id = tc.id join clientes c on tc.cliente_id = c.id ").where("c.fecha_asignacion < ordenes.fecha_pedido and c.vendedor_id = ?", u).group_by_day(:fecha_pedido, last: 30).sum("total")

	end

	def self.ventas_mes_vendedor(u)
		joins("join tiendas_clientes tc on ordenes.tienda_cliente_id = tc.id join clientes c on tc.cliente_id = c.id ").where("c.fecha_asignacion < ordenes.fecha_pedido and c.vendedor_id = ?", u).group_by_month(:fecha_pedido, last: 12).sum("total")
	end

	def self.ventas_cliente_vendedor(u)
		joins("join tiendas_clientes tc on ordenes.tienda_cliente_id = tc.id join clientes c on tc.cliente_id = c.id ").where("c.fecha_asignacion < ordenes.fecha_pedido and c.vendedor_id = ?", u).group("c.nombre").sum("total")
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
