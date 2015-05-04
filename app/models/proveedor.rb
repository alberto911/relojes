class Proveedor < ActiveRecord::Base
	has_many :relojes, inverse_of: :proveedor, dependent: :destroy
  has_many :pedidos, inverse_of: :proveedor
	
	validates :nombre, :telefono, :direccion, :rfc, presence: true
  validates :nombre, :telefono, :rfc, uniqueness: true  
	validates :nombre, :direccion, length: { maximum: 50 }
  validates :telefono, length: { in: 8..10 }, numericality: true
  validates :rfc, length: { is: 13 }

	default_scope { where(activo: true) }

	def self.to_csv
		CSV.generate do |csv|
		  csv << ['id', 'nombre', 'teléfono', 'dirección', 'RFC']
		  all.each do |prov|
				csv << [prov.id, prov.nombre, prov.telefono, prov.direccion, prov.rfc]
		  end
  	end
	end

	def self.con_relojes
		Proveedor.joins(:relojes).distinct.order('nombre asc')
  end
end
