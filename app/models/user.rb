class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable

  has_one_attached :photo
  has_one :care_receiver
  has_many :sites
  acts_as_token_authenticatable
end
