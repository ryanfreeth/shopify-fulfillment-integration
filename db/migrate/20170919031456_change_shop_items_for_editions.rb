class ChangeShopItemsForEditions < ActiveRecord::Migration[5.1]
  def change
    add_reference :shop_items, :edition, index: true
    add_column :shop_items, :shop, :string
    add_column :shop_items, :sku, :string
    add_column :shop_items, :nw_sku, :string
    remove_index :shop_items, name: "index_shop_items_on_title_and_size"
    remove_column :shop_items, :title
    remove_column :shop_items, :size
  end
end
