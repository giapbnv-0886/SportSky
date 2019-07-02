class Timeframe < ApplicationRecord
  belongs_to :pitch

  validates :starttime, presence: true
  validates :endtime, presence: true

  def combine_time
    "#{starttime.strftime "%k:%M" } - #{endtime.strftime "%k:%M" }"
  end

  def getstart
    starttime.time
  end

  def format_starttime
    "#{starttime.strftime "%k:%M" }"
  end

  def getend
    endtime.time
  end

  def format_endtime
    "#{endtime.strftime "%k:%M" }"
  end

  class << self
    def belong pitch
      Timeframe.where pitch_id: pitch.id
    end

  end
end
