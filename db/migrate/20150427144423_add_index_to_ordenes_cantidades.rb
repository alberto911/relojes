class AddIndexToOrdenesCantidades < ActiveRecord::Migration
  def change
		add_index(:ordenes_cantidades, [:orden_id, :reloj_id], unique: true)
  end
end
