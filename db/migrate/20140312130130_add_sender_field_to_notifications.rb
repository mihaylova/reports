class AddSenderFieldToNotifications < ActiveRecord::Migration
  def change
    add_reference :notifications, :sender, polymorphic: true
    remove_column :notifications, :admin_user_id
  end
end
