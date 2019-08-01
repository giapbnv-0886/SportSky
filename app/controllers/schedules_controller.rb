class SchedulesController < ApplicationController
  before_action :correct_user
  before_action :get_pitch, only: %i(new create)
  before_action :correct_schedule, except: %i(index new create)
  before_action :correct_status, only: %i(edit update destroy)
  before_action :get_timeframe, :get_cost, only: %i(create)

  def index
    @user_schedules = current_user.schedules.sorted.
      page(params[:page]).per Settings.schedule.page.per
  end

  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new; end

  def create
    @schedule = @pitch.schedules.build schedule_params
    if @schedule.save
      flash[:success] = t "schedule.create.success"
      redirect_to @schedule
    else
      flash[:danger] = t "schedule.create.save_error"
      redirect_back_or root_path
    end

  end

  def edit;  end

  def update
    if @schedule.update_attributes update_params
      flash[:info] = t "schedule.update.accepted"
      redirect_to @schedule
    else
      flash[:danger] = t "schedule.update.error"
      redirect_back_or root_path
    end
  end

  def destroy; end

  private
    def schedule_params
      (params.require(:schedule).permit :date).merge({starttime: @timeframe.starttime,
        endtime: @timeframe.endtime, cost: @cost, user_id: @user.id})
    end

    def update_params
      params.require(:schedule).permit :date, :starttime, :endtime, :cost, :status_id
    end

    def correct_user
      @user = current_user
      return if @user and @user == current_user
      flash[:warning] = t "users.alert.login"
      store_location
      redirect_to login_path
    end

    def get_pitch
      @pitch = Pitch.find_by id: params[:pitch_id]
      return if @pitch
      flash[:error] = t "schedule.create.pitch_error"
      redirect_back_or root_path
    end

    def get_timeframe
      @timeframe = Timeframe.find_by id: params[:schedule_timeframe_id]
      return if @timeframe
      flash[:danger] = t "schedule.show.timeframe_error"
      redirect_back_or root_path
    end

    def get_cost
      @cost = get_price params[:schedule][:date].to_date, params[:schedule_timeframe_id].to_i
      return if @cost
      flash[:danger] = t "schedule.show.timeframe_error"
      redirect_back_or root_path
    end

    def correct_schedule
      @schedule = Schedule.find_by id: params[:id]
      return if  @schedule && @schedule.user.was?(current_user) ||
        @schedule.pitch.sportground.user.was?(current_user)
      flash[:danger] = t "schedule.show.schedule_error"
      redirect_to root_path
    end

    def correct_status
      store_location
      return if @schedule.status.id == 1
      flash[:warning] = t "schedule.edit.error_status"
      redirect_back_or @schedule
    end

    def get_price date, timeframe_id
      return nil unless
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
       0
    end
end
