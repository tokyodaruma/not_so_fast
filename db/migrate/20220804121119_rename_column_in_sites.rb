class RenameColumnInSites < ActiveRecord::Migration[6.1]
  def change
    change_column_default :sites, :blocked, from: true, to: false
    change_column_default :sites, :trusted, from: true, to: false
    rename_column :sites, :trusted, :trust_with_popup
  end
end
