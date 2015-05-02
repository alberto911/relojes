class Orden < ActiveRecord::Base
	belongs_to :tienda_cliente, inverse_of: :ordenes
	belongs_to :repartidor, inverse_of: :ordenes
	has_many :ordenes_cantidades
	has_many :relojes, through: :ordenes_cantidades

	validates :tienda_cliente_id, presence: true

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

	def self.ventas_dia
		data = {}
		Orden.all.map do |o|
			fecha = o.created_at.to_date
			data.has_key?(fecha) ? data[fecha] += o.total : data[fecha] = o.total
		end
		data
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

end
