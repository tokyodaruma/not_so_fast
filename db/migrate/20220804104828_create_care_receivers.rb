class CreateCareReceivers < ActiveRecord::Migration[6.1]
  def change
    create_table :care_receivers do |t|
      t.string :first_name
      t.string :last_name
      t.string :chrome_id
      t.string :relationship

      t.timestamps
    end
  end
end
