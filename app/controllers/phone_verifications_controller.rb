class PhoneVerificationsController < ApplicationController
  before_action :correct_user, except: %i(show delete)

  def new; end

  def create
    if @user.phone_confirm_expired?
      @phone_number = params[:verify][:phone]
      @user.create_phone_digest
      @user.send_phone_verify_message_to @phone_number
      flash[:info] = t "users.verify.sent"
      redirect_to edit_phone_verifications_path
    else
      flash[:warning] = t "users.verify.time_expired"
      render :new
    end

  end

  def edit; end

  def update
    if @user.authenticated? :phone, params[:verify][:pin]
      @user.verify_phone
      flash[:success] = t "users.verify.verified"
      redirect_back_or @user
    else
      flash[:danger] = t "users.verify.error_pin"
      render :edit
    end
  end

  private
  def correct_user
    @user = current_user
    return if @user
    store_location
    flash[:warning] = t "users.verify.login"
    redirect_to login_url
  end
end
