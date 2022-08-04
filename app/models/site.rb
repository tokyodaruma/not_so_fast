class Site < ApplicationRecord
  belongs_to :user
  belongs_to :notification

  validates :blocked, inclusion: [true, false]
  validates :trusted, inclusion: [true, false]
  validates :reason, presence: true
  validates :url, presence: true
  validates :referral_site, presence: true
end
