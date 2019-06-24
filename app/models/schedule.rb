class Schedule < ApplicationRecord
  belongs_to :pitch
  belongs_to :user
  has_one :status
end
