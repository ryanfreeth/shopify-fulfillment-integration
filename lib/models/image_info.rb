
class ImageInfo < ActiveRecord::Base
  validates :title, uniqueness: { scope: :size }
end
