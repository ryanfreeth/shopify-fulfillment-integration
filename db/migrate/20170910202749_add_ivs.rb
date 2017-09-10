class AddIvs < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :token_encrypted_iv, :string
    add_column :fulfillment_services, :username_encrypted_iv, :string
    add_column :fulfillment_services, :password_encrypted_iv, :string
  end
end
