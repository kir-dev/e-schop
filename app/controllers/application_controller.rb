class ApplicationController < ActionController::Base
  before_action :session_check
  def session_check
    if current_user.nil?
      flash[:alert] = t(:no_current_user)
      redirect_to action: 'index', controller: 'eschop'
    end
  end

  def check_good_id
    if Good.find_by_id(params[:id]).nil?
      redirect_to action: 'landing', controller: 'goods'
    end
  end

  def current_user
    @current_user = User.find_by_id(session[:user_id])
  end
  helper_method :current_user
end