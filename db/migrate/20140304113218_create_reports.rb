class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :text, :null => false
      t.references :user
      t.timestamps
    end
  end
end
