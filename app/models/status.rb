class Status < ApplicationRecord
  has_many :schedules, dependent: :nullify
end
