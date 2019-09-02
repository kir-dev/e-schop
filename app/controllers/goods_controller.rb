# frozen_string_literal: true

class GoodsController < ApplicationController
  include ProductsHelper

  before_action :force_json, only: :autocomplete

  def index
    @goods = getSelectedGoods
    @products = Product.with_attached_photo.all
    @sellers = find_sellers_for_goods(@goods)

    @recommendtaions = Recommendations.new(current_user).get_recommendations_from(@goods) unless current_user.nil?
  end

  def getSelectedGoods
    goods = Good.with_attached_photo.all.order(name: :asc, created_at: :desc)
    unless params[:post].blank? || params[:post][:category_id].blank?
      goods = goods.select { |g| g.category_id == params[:post][:category_id].to_i }
    end
    unless params[:scearched_prase].blank?
      goods = goods.select { |g| g.name.downcase.include?(params[:scearched_prase].downcase) }
    end
    goods
  end

  def show
    @good = Good.with_attached_photo.find(params[:id])
    @product = Product.with_attached_photo.find(params[:id])
    @user = User.find_by_id(@good.seller_id)
    @order = Good.new
    UserIntrests.new(current_user).add_good_tags(@good) unless current_user.nil?
  end

  def view
    unless current_user.nil?
      good = Good.with_attached_photo.find(params[:id])
      UserIntrests.new(current_user).add_good_tags(good) unless current_user.nil?
    end
  end

  def edit
    @good = Good.find_by_id(params[:id])
    @categories = Category.all
  end

  def update
    @good = Good.find_by_id(params[:id])

    if @good.update_attributes(good_params)
      redirect_to controller: 'users', action: 'good_show', id: @good.id
    else
      @categories = Category.all
      render action: 'edit'
    end
  end

  def new
    @categories = Category.all
  end

  def create
    @product = Product.new(product_params)
    @product.save
    @good = Good.new(good_params)

    @good.seller_id = current_user.id
    @good.product_id = @product.id
    if @good.save
      add_good_tags_from_params(@good)
      redirect_to controller: 'users', action: 'good_show', id: @good.id
    else
      render action: 'new'
    end
  end

  def delete_num
    @good = Good.find_by_id(params[:id])
    @number = Good.new
  end

  def destroy
    @good = Good.find_by_id(params[:id])
    @good.update_attributes(number: 0)
    @good.destroy
    redirect_to controller: 'users', action: 'my_goods'
  end

  def delete
    @good = Good.find(params[:id])
    if params[:good].nil?
      @good.destroy
      redirect_to controller: 'users', action: 'my_goods'
    else
      number = params[:good][:number].to_f
      if @good.number > number
        new_num = @good.number - number
        @good.update_attributes(number: new_num)
        flash[:alert] = t(:good_deleted)
        redirect_to controller: 'users', action: 'good_show', id: @good.id
      else
        @good.destroy
        flash[:alert] = t(:good_deleted)
        redirect_to controller: 'users', action: 'my_goods'
      end
    end
  end

  def for_u
    byebug
    @goods = Good.with_attached_photo.limit(8)
    @products = get_proucts_for_goods(@goods)
  end

  def food
    @goods = Good.with_attached_photo.where(category_id: 1)
    @products = get_proucts_for_goods(@goods)
    @sellers = find_sellers_for_goods(@goods)
  end

  def drink
    @goods = Good.with_attached_photo.where(category_id: 2)
    @products = get_proucts_for_goods(@goods)
    @sellers = find_sellers_for_goods(@goods)
  end

  def else
    @goods = Good.with_attached_photo.where(category_id: 3)
    @products = get_proucts_for_goods(@goods)
    @sellers = find_sellers_for_goods(@goods)
  end

  def search
    term = params[:scearched_prase].downcase
    @tags = Tag.select { |tag| tag.name.include?(term) }
    @goods = Good.select { |good| good.name.downcase.include?(term) }

    respond_to do |format|
      format.html {}
      format.json do
        @tags = @tags.take(3)
        @goods = @goods.take(3)
      end
    end
  end

  def autocomplete
    tag_name = params[:q].downcase
    @tags = Tag.select { |tag| tag.name.include?(tag_name) }

    respond_to do |format|
      format.json
    end
  end

  def show_goods_with_tag
    @goods = Tag.find(params[:id]).goods
    @products = get_proucts_for_goods(@goods)
    @sellers = find_sellers_for_goods(@goods)
  end

  private

  def good_params
    params.require(:good).permit(:name, :price, :text, :description, :number, :category_id)
  end

  def product_params
    params.require(:good).permit(:name, :photo, :category_id)
  end

  def force_json
    request.format = :json
  end

  def find_sellers_for_goods(goods)
    seller_ids = []
    goods.each do |good|
      seller_id = good.seller_id
      seller_ids.push(seller_id) unless seller_ids.include?(seller_id)
    end
    User.where(id: seller_ids)
  end
end
