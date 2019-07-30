class CheckingtimeframesController < ApplicationController
  before_action :correct_pitch

  def show
    @date = params[:date].to_date
    @time_availables = get_time_frames_for @date
    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
    end
  end
  private

  def get_time_frames_for date
    @pitch.timeframes
  end

  def correct_pitch
    @pitch = Pitch.find_by id: params[:pitch_id]
    redirect_to root_path unless @pitch
  end

end
