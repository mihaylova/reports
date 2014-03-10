class AddRoleFieldToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :admin
    add_column :users, :role, :string
  end
end
