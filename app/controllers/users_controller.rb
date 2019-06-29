class UsersController < ApplicationController
  before_action :check_good_id, only: [:good_show]

  def show
    @purchases = Purchase.all
    @goods = Good.all
  end

  def good_show
    @good = Good.with_deleted.find(params[:id])
  end

  def my_cart
    @purchases = Purchase.all
  end

  def my_goods
    @goods = Good.without_deleted.all
  end

  def sold_goods
    @purchases = Purchase.all
  end

  def show_other_user
    @user = User.find(params[:id])
  end
end
