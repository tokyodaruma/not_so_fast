class Site < ApplicationRecord
  belongs_to :user
  belongs_to :notification

  validates :blocked, inclusion: [true, false]
  validates :trust_with_popup, inclusion: [true, false]
  validates :reason, presence: true
  validates :url, presence: true
end
