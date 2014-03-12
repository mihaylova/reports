class RemoveEditorToLastEditorInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :editor_id, :last_editor_id
  end
end
