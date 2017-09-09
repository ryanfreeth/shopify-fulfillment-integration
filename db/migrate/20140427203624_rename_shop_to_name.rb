class RenameShopToName < ActiveRecord::Migration[5.1]
  def self.up
    rename_column :shops, :shop, :name
  end

  def self.down
    rename_column :shops, :name, :shop
  end
end
