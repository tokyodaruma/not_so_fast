class CareReceiver < ApplicationRecord
  validates :first_name, :last_name, presence: true
  validates :chrome_id, uniqueness: true
  has_one :user
end
