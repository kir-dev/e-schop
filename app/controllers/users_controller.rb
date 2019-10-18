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
    if !params[:new_room].nil?
      good_number = 0
      Good.all.each do |g|
        good_number += 1 if g.seller_id == current_user.id
      end
      level_num_update(-good_number, current_user.roomnumber)
      current_user.update_attributes(roomnumber: params[:new_room])
      level_num_update(good_number, current_user.roomnumber)
    end
    if !params[:new_description].nil?
      current_user.update_attributes(description: params[:new_description])
    end
    if params[:want_email] == 'Igen'
      current_user.update_attributes(want_email: true)
    else
      current_user.update_attributes(want_email: false)
    end
    redirect_to user_path
  end
end
