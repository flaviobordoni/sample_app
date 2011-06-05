class AddPwdfieldToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :password_encrypted, :string
  end

  def self.down
    remove_column :users, :password_encrypted
  end
end
