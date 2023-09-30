class ApplicationController < ActionController::Base
  helper_method :authorized_user?
  helper_method :current_user
  before_action :authorized
  helper_method :logged_in?

  def current_user
    # if session[:is_admin]
    #   @current_user = Admin.find(session[:user_id])
    if session[:user_id]
      @current_user ||= Passenger.find(session[:user_id])
    else
      @current_user = nil
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def authorized
    redirect_to root_path unless logged_in?
  end

  def authorized_user?(id)
    logged_in? && @current_user == Passenger.find_by_id(id) 
  end
end
