class AddIndexToShops < ActiveRecord::Migration[5.1]
  def self.up
    add_index :shops, :shop
  end

  def self.down
    remove_index :shops, :shop
  end
end
