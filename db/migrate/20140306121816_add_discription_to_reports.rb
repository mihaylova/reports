class AddDiscriptionToReports < ActiveRecord::Migration
  def change
    add_column :reports, :discription, :text
    remove_column :reports, :text
  end
end
