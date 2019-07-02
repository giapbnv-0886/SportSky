module PitchesHelper
  def create_cwday_array
    cw = []
    Date::DAYNAMES.each {|d| cw << d.to_date.cwday}
    return [Date::DAYNAMES, cw]
  end

  def week_collection_from today
    week =[]
    today.upto(today + 7) {|d| week<<d}
    week.collect{ |d| ["#{Date::ABBR_DAYNAMES[d.wday]} (#{d.to_s})",d] }
  end

  def create_timeframe s_time, e_time, step
    unless step > 0
      flash[:danger] = t "pitch.alert.step_error"
      redirect_to root_path
    end
    timeframes = []
    i = 0
    while s_time + (i*step).hours < e_time
      s= s_time + (i*step).hours
      i+=1
      e= s_time + (i*step).hours
      timeframes << [s,e]
    end
    return timeframes
  end
end
