class AddLastEditorFieldForReports < ActiveRecord::Migration
  def change
    add_reference :reports, :editor, polymorphic: true
  end
end
