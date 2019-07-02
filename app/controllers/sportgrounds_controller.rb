class SportgroundsController < ApplicationController
  before_action :logged_in_user, :correct_user, except: %i(index show)
  before_action :correct_sportground, except: %i(index show new create)

  def index; end

  def show
    @sportground = Sportground.find_by id: params[:id]
    if @sportground
      @pitches = @sportground.pitches.page(params[:page]).per Settings.pitch.page.per
    else
      flash[:danger] = t "sportground.create.alert.failed"
      redirect_to root_path
    end
  end

  def new
    @sportground = @user.sportgrounds.build
  end

  def create
    @sportground = @user.sportgrounds.build sportground_params
    respond_to do |format|
      if @sportground.save
        format.html{
          flash[:info] = t "sportground.create.alert.success"
          redirect_to @user
        }
      else
        format.html{ render :new }
      end
    end
  end

  def edit; end

  def update
    if @sportground.update_attributes sportground_params
      redirect_to @sportground
    else
      render :edit
    end
  end

  def destroy
    if @sportground.destroy
      flash[:info] = t "sportground.delete.alert.success"
    else
      flash[:danger] = t "sportground.delete.alert.failed"
    end
  end

  private

  def correct_user
    @user = current_user
    return if @user == current_user
    flash[:warning] = t "users.alert.login"
    redirect_to login_path
  end

  def correct_sportground
    @sportground = Sportground.find_by id: params[:id]
    return if @sportground and @sportground.user.was?(@user)
    flash[:warning] = t "sportground.update.alert.permit"
    redirect_to root_path
  end

  def sportground_params
    params.require(:sportground)
        .permit :name, :address,:opentime, :closetime, :phone, :sportgroundtype_id, {photos: []}
  end
end
