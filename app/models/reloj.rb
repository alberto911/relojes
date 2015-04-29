class Reloj < ActiveRecord::Base
	belongs_to :proveedor, inverse_of: :relojes
	has_many :ordenes_cantidades
	has_many :ordenes, through: :ordenes_cantidades	
	
	validates :marca, :modelo, :descripcion, :precio, :proveedor_id, presence: true
	validates :modelo, uniqueness: true
	validates :marca, :modelo, length: { maximum: 25 }
  validates :descripcion, length: { maximum: 100 }
  validates :precio, format: { with: /\A\d{1,6}(?:\.\d{0,2})?\z/, message: "debe tener máximo 6 dígitos enteros y 2 decimales" }
end
