class AddFechaPedido < ActiveRecord::Migration
  def change
		add_column :ordenes, :fecha_pedido, :date
		add_column :pedidos, :fecha_pedido, :date
  end
end
