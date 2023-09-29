class SessionsController < ApplicationController
  skip_before_action :authorized, only: [:new, :create, :newAdmin, :createAdmin]

  def new
  end
  
  def newAdmin
  end

  def create
    if params[:username]
      admin = Admin.find_by_username(params[:username])
      if admin && admin.password==params[:password]
        session[:user_id] = admin.id
        session[:is_admin] = true
        redirect_to root_url
      else
        flash.now[:alert] = "Username or password is invalid"
        render "new"
      end
    else
      user = Passenger.find_by_email(params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        session[:is_admin] = false
        redirect_to root_url
      else
        flash.now[:alert] = "Email or password is invalid"
        render "new"
      end
    end
  end

  def createAdmin
    admin = Admin.find_by_username(params[:username])
    if admin && admin.password==params[:password]
      session[:user_id] = admin.id
      redirect_to root_url
    else
      flash.now[:alert] = "Username or password is invalid"
      render "new"
    end
  end


  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end