# frozen_string_literal: true

class GoodsController < ApplicationController
  include ProductsHelper
  include GoodsHelper

  before_action :force_json, only: :autocomplete

  def index
    @index = true
    @goods = getSelectedGoods
    @products = Product.with_attached_photo.all
    @sellers = find_sellers_for_goods(@goods)

    @recommendtaions = Recommendations.new(current_user).get_recommendations_from(@goods) unless current_user.nil?
  end

  def getSelectedGoods
    goods = Good.with_attached_photo.all.order(name: :asc, created_at: :desc).includes(:tags)
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
    @main_tags = Tag.where(category: true)
  end

  def update
    @good = Good.find_by_id(params[:id])

    if @good.update_attributes(good_params)
      tag_num_update(-1, @good.tags)
      add_good_tags_from_params(@good)
      tag_num_update(1, @good.tags)
      redirect_to controller: 'users', action: 'good_show', id: @good.id
    else
      @main_tags = Tag.where(category: true)
      render action: 'edit'
    end
  end

  def new
    @main_tags = Tag.where(category: true)
  end

  def create
    @product = Product.new(product_params)
    @product.save
    @good = Good.new(good_params)

    @good.seller_id = current_user.id
    @good.product_id = @product.id
    if @good.save
      level_num_update(1, current_user.roomnumber)
      add_good_tags_from_params(@good)
      tag_num_update(1, @good.tags)
      @product.tags = @good.tags
      @product.save
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
    number = @good.number
    @good.update_attributes(number: 0)
    level_num_update(-1, current_user.roomnumber)
    tag_num_update(-1, @good.tags)
    @good.destroy
    flash[:notice] = number.to_s + ' terméket töröltél'
    redirect_to controller: 'users', action: 'my_goods', method: :get
  end

  def delete
    @good = Good.find(params[:id])
    if params[:good].nil?
      level_num_update(-1, current_user.roomnumber)
      tag_num_update(-1, @good.tags)
      @good.destroy
      redirect_to controller: 'users', action: 'my_goods'
    else
      number = params[:good][:number].to_f
      if @good.number > number
        new_num = @good.number - number
        @good.update_attributes(number: new_num)
        flash[:notice] = t(:good_deleted)
        redirect_to controller: 'users', action: 'good_show', id: @good.id, method: :get
      else
        tag_num_update(-1, @good.tags)
        level_num_update(-1, current_user.roomnumber)
        @good.destroy
        flash[:notice] = t(:good_deleted)
        redirect_to controller: 'users', action: 'my_goods', method: :get
      end
    end
  end

  def for_u
    @goods = Good.with_attached_photo.all
    @recommendtaions = get_recommendations(50) unless current_user.nil?
    @products = get_proucts_for_goods(@goods)
  end

  def search
    term = if params[:index_phrase].nil?
             params[:scearched_prase].downcase
           else
             params[:index_phrase].downcase
           end

    @tags = Tag.select { |tag| tag.name.include?(term) }
    @goods = Good.select { |good| good.name.downcase.include?(term) }

    respond_to do |format|
      format.html do
        @goods = Good.select { |good| good.name.downcase.include?(term) || !(@tags & good.tags).empty? }
      end
      format.json do
        @tags = @tags.take(3)
        @goods = @goods.take(3)
      end
    end
  end

  def index_search
    term = params[:index_phrase].downcase
    @tags = Tag.select { |tag| tag.name.include?(term) }
    @goods = Good.select { |good| good.name.downcase.include?(term) }

    respond_to do |format|
      format.html do
        @goods = Good.select { |good| good.name.downcase.include?(term) || !(@tags & good.tags).empty? }
      end
      format.json do
        @tags = @tags.take(3)
        @goods = @goods.take(3)
        render 'search.json'
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

  def add_good_tags_to_user_intrests(good)
    good.tags.each do |tag|
      intrest_in_tag = current_user.intrests.find { |intrest| intrest.tag == tag }
      if intrest_in_tag.nil?
        new_intrest = current_user.intrests.create(rate: 1)
        new_intrest.tag = tag
        new_intrest.save
      else
        intrest_in_tag.rate += 1
        intrest_in_tag.save
      end
    end
  end

  def add_good_tags_from_params(good)
    return if good.nil?

    selected_tags = params[:selected_tags].split('#')
    selected_tags.unshift(params[:good][:main_tag]) unless params[:good][:main_tag].nil?
    tags = Tag.all
    selected_tags.each do |tag|
      if tags.any? { |t| t.name == tag }
        good.tags << tags.find { |t| t.name == tag }
      else
        new_tag = Tag.create(name: tag)
        good.tags << new_tag
      end
    end
  end

  def get_recommendations(recommendations_count, _recommendation_per_tag_number = 2)
    recommendations = []
    user_favourite_tags.each do |tag|
      recommendations_per_tag = @goods.select { |good| good.tags.include?(tag) && !recommendations.include?(good) }
      recommendations_per_tag = recommendations_per_tag.first(2)

      recommendations_count -= recommendations_per_tag.size
      recommendations_per_tag.each do |rec|
        recommendations.push(rec)
      end
    end
    recommendations_from_other = Good.limit(recommendations_count).select { |good| !good.tags.include?(user_favourite_tags) && !recommendations.include?(good) }
    recommendations_from_other.each do |rec|
      recommendations.push(rec)
    end
    recommendations
  end

  def user_favourite_tags
    top_intrests = current_user.intrests.order(rate: :desc).limit(3)
    favourite_tags = []
    top_intrests.each do |intrest|
      favourite_tags.push(intrest.tag)
    end
    favourite_tags
  end

  def total_intrest_rate_in_tag(tag)
    total_intrest_rate = 0

    User.all.each do |user|
      user_intrest = user.intrests.find { |intrest| intrest.tag == tag }
      total_intrest_rate += user_intrest.rate unless user_intrest.nil?
    end

    total_intrest_rate
  end

  def force_json
    request.format = :json
  end
end
