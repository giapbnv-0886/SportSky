class PitchesController < ApplicationController
  before_action :set_sportground, only: %i(new create)
  before_action :set_pitch, except: %i(new create)
  before_action :correct_user, except: %i(index show)
  before_action :correct_pitch, only: %i(edit update destroy)

  def index
    @pitches = Pitch.all
  end

  def show
    @sportground = @pitch.sportground
  end

  def new
    @pitch = @sportground.pitches.build
    @pitchtypes = @sportground.sportgroundtype.pitchtypes

  end

  def edit
    @sportground = @pitch.sportground
    @pitchtypes = @sportground.sportgroundtype.pitchtypes
    @timeframes = @pitch.timeframes
    @menus = @pitch.menus
  end

  def create
    @pitch = @sportground.pitches.build pitch_params
    respond_to do |format|
      if @pitch.save
        format.html do
          flash[:info] = t "pitch.alert.created"
          redirect_to edit_pitch_path @pitch
        end
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @pitch.update pitch_params
        format.html do
          flash[:info] = t "pitch.edit.success"
          redirect_to @pitch
        end
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @pitch.destroy
    respond_to do |format|
      format.html do
        flash[:danger] = t "pitch.delete.success"
        redirect_to @pitch.sportground
      end
    end
  end

  private
    def set_pitch
      @pitch = Pitch.find_by id: params[:id]
      unless @pitch
        flash[:danger] = t "pitch.form.alert.error"
        redirect_to root_path
      end
    end

    def set_sportground
      @sportground = Sportground.find_by id: params[:sportground_id]
      return if @sportground
      flash[:danger] = t "pitch.form.alert.error"
      redirect_to root_path
    end

    def correct_user
      @user = current_user
      return if @user and @user == current_user
      flash[:warning] = t "users.alert.login"
      redirect_to login_path
    end

    def correct_pitch
      return if @pitch and current_user.pitches.include? @pitch
      flash[:danger] = t "pitch.form.alert.error"
      redirect_to root_path
    end

    def pitch_params
      params.require(:pitch).permit :name, :pitchtype_id, :minrental,
        menus_attributes: [:id, :startday, :endday, :starttime, :endtime, :price, :_destroy],
          timeframes_attributes: [:id, :starttime, :endtime, :_destroy]
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

  def redirect_edit
    redirect_to edit_pitch_path @pitch
  end
end
