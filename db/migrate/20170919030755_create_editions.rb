class CreateEditions < ActiveRecord::Migration[5.1]
  def change
    create_table :editions do |t|
      t.integer :edition
      t.integer :total_editions
    end
  end
end
