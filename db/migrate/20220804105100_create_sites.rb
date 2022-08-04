class CreateSites < ActiveRecord::Migration[6.1]
  def change
    create_table :sites do |t|
      t.boolean :blocked
      t.boolean :trusted
      t.references :user, null: false, foreign_key: true
      t.references :notification, null: false, foreign_key: true
      t.text :reason
      t.string :url
      t.string :referral_site

      t.timestamps
    end
  end
end
