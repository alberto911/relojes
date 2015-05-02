class AddFechaAsignacionToClientes < ActiveRecord::Migration
  def change
		add_column :clientes, :fecha_asignacion, :timestamp
		remove_column :repartidores, :activo
  end
end
