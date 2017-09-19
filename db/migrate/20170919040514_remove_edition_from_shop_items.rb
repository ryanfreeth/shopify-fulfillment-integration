class RemoveEditionFromShopItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :shop_items, :edition
    remove_column :shop_items, :total_editions
  end
end
