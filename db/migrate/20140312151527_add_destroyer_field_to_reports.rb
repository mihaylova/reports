class AddDestroyerFieldToReports < ActiveRecord::Migration
  def change
    add_reference :reports, :destroyer, polymorphic: true
  end
end
