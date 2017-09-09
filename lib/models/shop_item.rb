
class ShopItem < ActiveRecord::Base
  validates :title, uniqueness: { scope: :size }
end
