class AddReportsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reports_count, :integer, default: 0
  end
end
