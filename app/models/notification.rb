class Notification < ApplicationRecord
  belongs_to :user
  has_one :site

  validates :accessed_at, :description, presence: true
  validates :read, exclusion: [nil]
end
