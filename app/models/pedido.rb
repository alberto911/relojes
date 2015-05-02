class Pedido < ActiveRecord::Base
	belongs_to :proveedor, inverse_of: :pedidos
	has_many :pedidos_cantidades, dependent: :destroy
	has_many :relojes, through: :pedidos_cantidades

	validates :proveedor_id, presence: true

	def proveedor
		Proveedor.unscoped.where(id: proveedor_id).first
	end

	def recibido?
		!fecha_entrega.nil?
	end

	def total
		if fecha_pedido
			read_attribute(:total)
		else
			total = 0
			pedidos_cantidades.each do |pc|
				total += pc.subtotal
			end
			total
		end
	end

	def self.compras_dia
		select("total").group_by_day(:fecha_pedido, last: 30 ).sum("total")
	end

	def self.compras_mes
		select("total").group_by_month(:fecha_pedido, last: 12).sum("total")
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
