class UpdateForGem < ActiveRecord::Migration[5.1]
  def self.up
    remove_index :fulfillment_services, :shop_id
    remove_column :fulfillment_services, :shop_id
    add_column :fulfillment_services, :shop, :string
    add_index :fulfillment_services, :shop
  end

  def self.down
    add_column :fulfillment_services, :shop_id
    add_index :fulfillment_services, :shop_id
    remove_index :fulfillment_services, :shop
    remove_column :fulfillment_services, :shop, :string
  end
end
