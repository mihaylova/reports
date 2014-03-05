class AddCategoryReportAssotiation < ActiveRecord::Migration
  def change
    add_reference :reports, :category
  end
end
