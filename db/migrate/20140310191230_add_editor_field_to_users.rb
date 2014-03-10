class AddEditorFieldToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :role
    add_column :users, :editor, :boolean, default: false 
  end
end
