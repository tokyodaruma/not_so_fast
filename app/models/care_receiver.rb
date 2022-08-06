class CareReceiver < ApplicationRecord
  validates :first_name, :last_name, presence: true
  validates :chrome_id, uniqueness: true
  belongs_to :user
end
