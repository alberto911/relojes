class Reloj < ActiveRecord::Base
	belongs_to :proveedor, inverse_of: :relojes
	has_many :ordenes_cantidades
	has_many :ordenes, through: :ordenes_cantidades
  has_many :pedidos_cantidades
  has_many :pedidos, through: :pedidos_cantidades
	
	validates :marca, :modelo, :descripcion, :precio, :proveedor_id, presence: { message: "no puede estar vacío" }
	validates :modelo, uniqueness: true
	validates :marca, :modelo, length: { maximum: 25 }
  validates :descripcion, length: { maximum: 100 }
  validates :precio, format: { with: /\A\d{1,6}(?:\.\d{0,2})?\z/, message: "debe tener máximo 6 dígitos enteros y 2 decimales" }

	def self.por_marca
	  joins("join proveedores p on relojes.proveedor_id = p.id").group("p.nombre").count
	end

	def self.precios
	  joins("join proveedores p on relojes.proveedor_id = p.id").group("p.nombre").average("precio")	
	end

	def self.rangos_precio
		{" $0 - $3000.00" => Reloj.select("id" ).where("precio<=3000").count,
				"$3000.01 - $6000.00" => Reloj.select("id" ).where("precio between 3000.01 and 6000").count,
				"$6000.01 - $12000.00" => Reloj.select("id" ).where("precio between 6000.01 and 12000").count,
				"$1200.00 +" => Reloj.select("id" ).where("precio >12000").count}
	end

	def self.stock_proveedor
		joins("join proveedores p on relojes.proveedor_id = p.id").group("p.nombre").sum("stock")
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
		OrdenCantidad.all.map do |oc|
			proveedor = oc.reloj.proveedor.nombre
			data.has_key?(proveedor) ? data[proveedor] += oc.subtotal : data[proveedor] = oc.subtotal
		end
		data
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
		PedidoCantidad.all.map do |pc|
			proveedor = pc.pedido.proveedor.nombre
			data.has_key?(proveedor) ? data[proveedor] += pc.subtotal : data[proveedor] = pc.subtotal
		end
		data
	end

end
