class Reloj < ActiveRecord::Base
	belongs_to :proveedor, inverse_of: :relojes
	has_many :ordenes_cantidades, dependent: :restrict_with_error
	has_many :ordenes, through: :ordenes_cantidades
  has_many :pedidos_cantidades, dependent: :restrict_with_error
  has_many :pedidos, through: :pedidos_cantidades
	
	validates :marca, :modelo, :descripcion, :precio, :proveedor_id, :costo, presence: true
	validates :modelo, uniqueness: true
	validates :marca, :modelo, length: { maximum: 25 }
  validates :descripcion, length: { maximum: 100 }
  validates :precio, format: { with: /\A\d{1,6}(?:\.\d{0,2})?\z/, message: "debe tener máximo 6 dígitos enteros y 2 decimales" }
	validates :costo, format: { with: /\A\d{1,6}(?:\.\d{0,2})?\z/, message: "debe tener máximo 6 dígitos enteros y 2 decimales" }

	default_scope { where(activo: true) }

	def self.to_csv
		CSV.generate do |csv|
		  csv << ['id', 'proveedor', 'línea', 'modelo', 'costo', 'precio', 'stock']
		  all.each do |reloj|
				csv << [reloj.id, reloj.proveedor.nombre, reloj.marca, reloj.modelo, reloj.costo, reloj.precio, reloj.stock]
		  end
  	end
	end

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
end
