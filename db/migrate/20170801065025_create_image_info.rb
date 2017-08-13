class CreateImageInfo < ActiveRecord::Migration
  def change
    create_table :image_info do |t|
      t.string :title
      t.string :size
      t.string :url
    end
    add_index :image_info, [:title, :size], unique: true
  end
end
