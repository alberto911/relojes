class CreateRepartidores < ActiveRecord::Migration
  def change
    create_table :repartidores do |t|
      t.string :nombre, null: false, limit: 50
      t.string :rfc, null: false, limit: 13
      t.string :telefono, null: false, limit: 10
      t.string :direccion, null: false, limit: 50
			t.integer :user_id, null: false

      t.timestamps null: false
    end
	
		add_foreign_key :repartidores, :users, name: 'fk_repartidores_users'
  end
end
