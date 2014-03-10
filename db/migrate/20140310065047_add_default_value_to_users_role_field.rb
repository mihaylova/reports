class AddDefaultValueToUsersRoleField < ActiveRecord::Migration
  def change
    change_column :users, :role, :string, default: "author"
  end
end
