class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:logged_on_user_id]) if session[:logged_on_user_id]
  end
  helper_method :current_user

end
