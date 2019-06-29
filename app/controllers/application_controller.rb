class ApplicationController < ActionController::Base
  def check_good_id
    if Good.with_deleted.find_by_id(params[:id]).nil?
      redirect_to action: 'landing', controller: 'goods'
    end
  end

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
