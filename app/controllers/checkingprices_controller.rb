class CheckingpricesController < ApplicationController
  before_action :correct_pitch

  def show
    @price = get_price params[:date].to_date, params[:timeframe_id].to_i
    respond_to do |format|
      format.html do
        redirect_to root_path
      end
      format.js
      format.html { redirect_to root_path }
    end
  end

  private

  def get_price date, timeframe_id
    return t "pitch.check_price.error_time" unless
        @pitch.timeframe_ids.include? timeframe_id
    menus = @pitch.menus
    tf = Timeframe.find_by id: timeframe_id
    menus.each do |m|
      if (m.startday.cwday..m.endday.cwday).include?date.cwday
        menu_times = (m.starttime.to_s(:time).to_time..m.endtime.to_s(:time).to_time)
        if menu_times.include?tf.starttime.to_s(:time).to_time and
            menu_times.include?tf.endtime.to_s(:time).to_time
          return m.price if m.price
        end
      end
    end
    t "pitch.check_price.error_time"
  end

  def correct_pitch
    @pitch = Pitch.find_by id: params[:pitch_id]
    redirect_to root_path unless @pitch
  end
end
