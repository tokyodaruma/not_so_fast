class AddDomainRecentAndTitletoSites < ActiveRecord::Migration[6.1]
  def change
    add_column :sites, :is_domain_recent, :string
    add_column :sites, :webpage_title, :string
  end
end
