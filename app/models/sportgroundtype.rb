class Sportgroundtype < ApplicationRecord
  has_one :sportground
  has_many :pitchtypes

  scope :sort_alphabet, -> { order(:name)}

end
