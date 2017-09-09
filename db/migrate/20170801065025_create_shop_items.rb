class CreateShopItems < ActiveRecord::Migration[5.1]
  def change
    create_table :shop_items do |t|
      t.string :title
      t.string :size
      t.string :url
      t.integer :edition
    end
    add_index :shop_items, [:title, :size], unique: true
  end
end
