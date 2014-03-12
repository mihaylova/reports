class AddLastEditorFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :editor_id, :integer
    add_index :users, :editor_id
  end
end
