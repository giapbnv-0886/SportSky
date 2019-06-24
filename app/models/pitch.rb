class Pitch < ApplicationRecord
  # has_many :timeframes
  # has_many :schedules
  # belongs_to :pitchtype
  # belongs_to :sportground
  has_and_belongs_to_many :menus
end
