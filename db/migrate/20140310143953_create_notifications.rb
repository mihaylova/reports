class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user
      t.references :admin_user
      t.text :message
      t.timestamps
    end
  end
end
