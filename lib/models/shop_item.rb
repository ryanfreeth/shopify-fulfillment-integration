
class ShopItem < ActiveRecord::Base
  belongs_to :edition, optional: true
  validates_presence_of :shop, :sku, :nw_sku
  validates_uniqueness_of :sku, scope: :shop
end
