class CreateShops < ActiveRecord::Migration[5.1]
  def self.up
    create_table :shops do |t|
      t.string :shop
      t.string :token
    end
  end

  def self.down
    drop_table :shops
  end
end
