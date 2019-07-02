class Pitch < ApplicationRecord
  has_many :timeframes, dependent: :destroy
  has_many :schedules
  belongs_to :pitchtype
  belongs_to :sportground
  has_many :menus, dependent:  :destroy
  accepts_nested_attributes_for :menus, allow_destroy: true,
    reject_if: proc { |attributes| attributes[:startday].blank? || attributes[:endday].blank? ||
      attributes[:starttime].blank? || attributes[:endtime].blank? }
  accepts_nested_attributes_for :timeframes, allow_destroy: true,
    reject_if: proc{ |attributes| attributes[:starttime].blank? ||
      attributes[:endtime].blank? }
  scope :sort_alphabet, -> { order :name }

end
