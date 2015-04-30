class CreatePedidosCantidades < ActiveRecord::Migration
  def change
    create_table :pedidos_cantidades do |t|
			t.integer :cantidad, null: false
			t.integer :pedido_id, null: false
			t.integer :reloj_id, null: false

      t.timestamps null: false
    end

    add_foreign_key :pedidos_cantidades, :pedidos, name: 'fk_pedidos_cantidades'
		add_foreign_key :pedidos_cantidades, :relojes, name: 'fk_pedidos_relojes'
  end
end
