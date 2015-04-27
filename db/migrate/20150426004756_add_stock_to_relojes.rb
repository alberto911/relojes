class AddStockToRelojes < ActiveRecord::Migration
  def change
		add_column :relojes, :stock, :integer, default: 0
  end
end
