class CreateRelojes < ActiveRecord::Migration
  def change
    create_table :relojes do |t|
      t.string :marca, null: false, limit: 25
      t.string :modelo, null: false, limit: 25
      t.text :descripcion, null: false, limit: 100
      t.decimal :precio, precision: 8, scale: 2, null: false
			t.integer :proveedor_id, null: false

      t.timestamps null: false

    end

		add_foreign_key :relojes, :proveedores, name: 'fk_relojes_proveedores'
  end
end
