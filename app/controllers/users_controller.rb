# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :check_good_id, only: [:good_show]
  include ProductsHelper
  def show
    @purchases = Purchase.all
    @goods = Good.all
  end

  def good_show
    @good = Good.with_deleted.find(params[:id])
  end

  def my_cart
    @purchases = Purchase.all.order(created_at: :desc)
  end

  def my_goods
    @goods = Good.with_attached_photo.without_deleted.all.order(updated_at: :desc)
    @products = get_proucts_for_goods(@goods)
  end

  def sold_goods
    @purchases = Purchase.all.order(created_at: :desc)
  end

  def show_other_user
    @user = User.find(params[:id])
  end
end
