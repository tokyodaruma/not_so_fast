class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :accessed_at
      t.text :description
      t.boolean :read

      t.timestamps
    end
  end
end
