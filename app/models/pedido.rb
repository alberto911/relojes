class Pedido < ActiveRecord::Base
	belongs_to :proveedor, inverse_of: :pedidos
	has_many :pedidos_cantidades, dependent: :destroy
	has_many :relojes, through: :pedidos_cantidades

	validates :proveedor_id, presence: true

	def recibido?
		!fecha_entrega.nil?
	end

	def total
	  	total = 0
		pedidos_cantidades.each do |pc|
			total += pc.subtotal
		end
		total
	end

	def self.compras_dia
		data = {}
		Pedido.all.map do |p|
			fecha = p.created_at.to_date
			data.has_key?(fecha) ? data[fecha] += p.total : data[fecha] = p.total
		end
		data
	end

	def self.compras_proveedor
		data = {}
		final = {}
		PedidoCantidad.all.map do |pc|
			proveedor = pc.pedido.proveedor.id
			data.has_key?(proveedor) ? data[proveedor] += pc.subtotal : data[proveedor] = pc.subtotal
		end
		data.map do |d|
			final[Proveedor.find(d.first).nombre] = d.second
		end
		final
	end
end
