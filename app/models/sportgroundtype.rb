class Sportgroundtype < ApplicationRecord
  has_one :sportground

  scope :sort_alphabet, -> { order(:name)}

end
