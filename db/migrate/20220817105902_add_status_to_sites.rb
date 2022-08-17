class AddStatusToSites < ActiveRecord::Migration[6.1]
  def change
    add_column :sites, :status, :integer
  end
end
