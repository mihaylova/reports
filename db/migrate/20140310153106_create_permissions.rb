class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :report
      t.boolean :author_can_delete, default: true
      t.boolean :author_can_edit, default: true
      t.boolean :editor_can_delete, default: true
      t.boolean :editor_can_edit, default: true

      t.timestamps
    end
  end
end
