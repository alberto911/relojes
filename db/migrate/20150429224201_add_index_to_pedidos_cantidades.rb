class AddIndexToPedidosCantidades < ActiveRecord::Migration
  def change
		add_index(:pedidos_cantidades, [:pedido_id, :reloj_id], unique: true)
  end
end
