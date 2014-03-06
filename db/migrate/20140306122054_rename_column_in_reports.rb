class RenameColumnInReports < ActiveRecord::Migration
  def change
    rename_column :reports, :discription, :description
  end
end
