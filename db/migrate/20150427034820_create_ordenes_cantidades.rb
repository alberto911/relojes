class CreateOrdenesCantidades < ActiveRecord::Migration
  def change
    create_table :ordenes_cantidades do |t|
      t.integer :cantidad, null: false
			t.integer :orden_id, null: false
			t.integer :reloj_id, null: false

      t.timestamps null: false
    end
	
		add_foreign_key :ordenes_cantidades, :ordenes, name: 'fk_ordenes_cantidades'
		add_foreign_key :ordenes_cantidades, :relojes, name: 'fk_cantidades_relojes'
  end
end
