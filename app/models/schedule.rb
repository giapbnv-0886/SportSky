class Schedule < ApplicationRecord
  belongs_to :pitch
  belongs_to :user
  belongs_to :status

  validates :starttime, :endtime, presence: true
  validate :valid_time
  validates :date, presence: true

  private

  def valid_time
    unless starttime < endtime
      errors.add(:time, I18n.t("schedule.validate.time"))
    end
  end
end
