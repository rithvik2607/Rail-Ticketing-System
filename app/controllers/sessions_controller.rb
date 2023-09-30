class SessionsController < ApplicationController
  skip_before_action :authorized, only: [:new, :create, :show]

  def new
  end
  
  def create
    # if params[:username]
    #   admin = Admin.find_by_username(params[:username])
    #   if admin && admin.password==params[:password]
    #     session[:user_id] = admin.id
    #     session[:is_admin] = true
    #     redirect_to root_url
    #   else
    #     flash.now[:alert] = "Username or password is invalid"
    #     render "new"
    #   end
    user = Passenger.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      # session[:is_admin] = false
      redirect_to root_url
    else
      respond_to do |format|
        format.html { redirect_to login_path, notice: "Email or password is invalid" }
        format.json { head :no_content }
      end
    end
  end

  # def createAdmin
  #   admin = Admin.find_by_username(params[:username])
  #   if admin && admin.password==params[:password]
  #     session[:user_id] = admin.id
  #     redirect_to root_url
  #   else
  #     flash.now[:alert] = "Username or password is invalid"
  #     render "new"
  #   end
  # end


  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end