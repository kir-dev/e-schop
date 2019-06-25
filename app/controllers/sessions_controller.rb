class SessionsController < ApplicationController
  skip_before_action :session_check, only: [:create, :login_params]

  def create
    user = User.find_by(username: login_params[:username])
    if user && user.authenticate(login_params[:password])
      session[:user_id] = user.id
      redirect_to '/'
    else
      redirect_to '/login', notice: t(:login_fail)
    end
  end

  def destroy
    reset_session
    redirect_to '/'
  end

  private

  def login_params
    params.require(:user).permit(:username, :password)
  end
end
