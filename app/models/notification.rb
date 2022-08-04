class Notification < ApplicationRecord
  belongs_to :user
  has_one :sites

  validates :accessed_at, :description, presence: true
  validates :read, exclusion: [nil]
end
