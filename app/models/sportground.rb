class Sportground < ApplicationRecord
  has_many :pitches
  has_many :rates
  belongs_to :user
  belongs_to :sportgroundtype

end
