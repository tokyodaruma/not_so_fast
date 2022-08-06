class AddUserIdToCareReceiver < ActiveRecord::Migration[6.1]
  def change
    add_reference :care_receivers, :user
  end
end
