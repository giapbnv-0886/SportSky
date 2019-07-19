class Pitchtype < ApplicationRecord
  has_many :pitches
  belongs_to :sportgroundtype
end
