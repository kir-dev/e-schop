class ApplicationController < ActionController::Base
  before_action :session_check
  def session_check
    if current_user.nil?
      flash[:alert] = t(:no_current_user)
      redirect_to action: 'index', controller: 'goods'
    end
  end

  def check_good_id
    if Good.with_deleted.find_by_id(params[:id]).nil?
      redirect_to action: 'landing', controller: 'goods'
    end
  end

  def current_user
    @current_user = User.find_by_id(session[:user_id])
  end
  helper_method :current_user

  def favourite_category
    purchases = Purchase.with_deleted.where(buyer_id: current_user.id).to_a
    if !purchases.empty?
      arr = []
      purchases.each do |p|
        arr.push Good.with_deleted.find_by_id(p.good_id).category_id
      end
      @favourite_category = arr.group_by { |e| e }.values.max_by { |values| values.size }.first
    else
      @favourite_category = -1
    end
  end
  helper_method :favourite_category
end