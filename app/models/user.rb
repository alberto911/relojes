class User < ActiveRecord::Base
	has_one :vendedor, inverse_of: :user
  has_one :repartidor, inverse_of: :user

	# Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	def tiene_permiso_sobre?(objeto)
		unless is_admin?
			vendedor == objeto.vendedor
		else
			true
		end
	end
end
