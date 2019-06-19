class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_locale

  private
  def default_url_options
    {locale: I18n.locale}
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def logged_in_user
    return if  logged_in?
    store_location
    flash[:danger] = t "users.alert.login"
    redirect_to login_path
  end
end
