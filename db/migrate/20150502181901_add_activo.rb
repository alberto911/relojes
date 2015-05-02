class AddActivo < ActiveRecord::Migration
  def change
		add_column :tiendas_clientes, :activo, :boolean, default: true
		add_column :clientes, :activo, :boolean, default: true
		add_column :proveedores, :activo, :boolean, default: true
		add_column :repartidores, :activo, :boolean, default: true
  end
end
