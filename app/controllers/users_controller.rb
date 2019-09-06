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

  def show; end

  def update
    if params[:new_room]
      current_user.update_attributes(roomnumber: params[:new_room])
    end
    if params[:new_description]
      current_user.update_attributes(description: params[:new_description])
    end
    redirect_to user_path
  end
end
