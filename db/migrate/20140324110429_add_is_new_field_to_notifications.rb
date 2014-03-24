class AddIsNewFieldToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :is_new, :boolean, default: true
  end
end
