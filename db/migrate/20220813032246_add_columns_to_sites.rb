class AddColumnsToSites < ActiveRecord::Migration[6.1]
  def change
    add_column :sites, :detections, :integer
    add_column :sites, :risk_score, :integer
  end
end
