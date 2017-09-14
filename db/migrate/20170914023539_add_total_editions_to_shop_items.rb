class AddTotalEditionsToShopItems < ActiveRecord::Migration[5.1]
  def change
    add_column :shop_items, :total_editions, :integer
  end
end
