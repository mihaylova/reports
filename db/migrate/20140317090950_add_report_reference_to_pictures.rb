class AddReportReferenceToPictures < ActiveRecord::Migration
  def change
    add_reference :pictures, :report
  end
end
