class EncryptTokens < ActiveRecord::Migration[5.1]
  def self.up
    rename_column :shops, :token, :token_encrypted
  end

  def self.down
    rename_column :shops, :token_encrypted, :token
  end
end
