class RemoveBooleansFromSites < ActiveRecord::Migration[6.1]
  def change
    remove_column :sites, :blocked, :boolean
    remove_column :sites, :trust_with_popup, :boolean
  end
end
