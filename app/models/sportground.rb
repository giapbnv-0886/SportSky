class Sportground < ApplicationRecord
  has_many :pitches
  has_many :rates
  belongs_to :user
  belongs_to :sportgroundtype, optional: true

  scope :recent, -> {order(:created_at)}
  mount_uploaders :photos, PhotoUploader

  validates :phone, presence: true, length: { maximum: Settings.user.phone.max_length }
end
