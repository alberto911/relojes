class OrdenCantidad < ActiveRecord::Base
	belongs_to :orden
	belongs_to :reloj

	validates :cantidad, :orden_id, :reloj_id, presence: true
  validates :cantidad, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 10000}

	before_create :validate_stock_create
  before_update :validate_stock_update
	after_create :decrease_stock
  after_update :update_stock
	after_destroy :increase_stock

	def subtotal 
		reloj.precio * cantidad
	end

	def reloj
		Reloj.unscoped.where(id: reloj_id).first
	end

	protected
		def validate_stock_create
			if cantidad > reloj.stock
				errors.add(:cantidad, 'mayor al stock.')
				false
			else
				true
			end
		end

		def validate_stock_update
			if (cantidad - cantidad_was) > reloj.stock
				errors.add(:cantidad, 'mayor al stock.')
				false
			else
				true
			end
		end

		def decrease_stock
			reloj.stock -= cantidad
			reloj.save
		end

		def update_stock
			reloj.stock -= (cantidad - cantidad_was)
			reloj.save
		end

		def increase_stock
			reloj.stock += cantidad
			reloj.save
		end
end
