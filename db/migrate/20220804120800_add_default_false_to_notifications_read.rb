class AddDefaultFalseToNotificationsRead < ActiveRecord::Migration[6.1]
  def change
    change_column_default :notifications, :read, from: true, to: false
  end
end
