class Site < ApplicationRecord
  belongs_to :user
  belongs_to :notification

  enum status: %i[blocked trusted pending]
  validates :status, inclusion: { in: statuses.keys }
  validates :reason, presence: true
  validates :url, presence: true
end
