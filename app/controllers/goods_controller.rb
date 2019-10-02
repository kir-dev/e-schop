# frozen_string_literal: true

class GoodsController < ApplicationController
  include ProductsHelper
  include GoodsHelper
  before_action :force_json, only: :autocomplete

  def index
    @goods, @levels = get_selected_goods()
    @order_by = params[:order_by]
    @order_direction = params[:order_direction]

    @selected_floors = set_selected_floors()
    @prev_tags_arr, @prev_tags_str = set_selected_tags()   
    @searched_phrase = params[:searched_phrase]

    @products = Product.with_attached_photo.all
    @sellers = find_sellers_for_goods(@goods)
    @tags = set_tags(@goods, @prev_tags_arr)
    @goods = @goods.paginate(page: params[:page], per_page: 25)
    @recommendtaions = get_recommendations(9) unless current_user.nil?
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

    add_good_tags_to_user_intrests(@good) unless current_user.nil?
  end

  def view
    unless current_user.nil?
      good = Good.with_attached_photo.find(params[:id])
      add_good_tags_to_user_intrests(good)
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
    flash[:notice] = number.to_s + " terméket töröltél"
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
    unless params[:good][:main_tag].nil?
      selected_tags.unshift(params[:good][:main_tag])
    end
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

  def get_recommendations(recommendations_count,recommendation_per_tag_number = 2)
    

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

  def filter_floor(goods)
    array = Array.new
    if params[:selected_floors].nil? || params[:selected_floors] == ""
      if params[:floors].nil?
        array = goods
      else
        selected_floors = params[:floors]
      end
    else
      selected_floors = params[:selected_floors].split('#')
    end
    unless selected_floors.nil?
      goods.each do |g|
        if selected_floors.include?(g.floor.to_s)
          array.push g
        end
      end
    end
    array
  end
  def filter_tag(goods, searched_tags = "")
    array = Array.new
    selected_tags_s = params[:selected_tags]
    if searched_tags != ""
        selected_tags_s = searched_tags
    end
    if selected_tags_s.nil? || selected_tags_s == ""
      array = goods
    else
      selected_tags = selected_tags_s.split('#')
    end
    unless selected_tags.nil?
      goods.each do |g|
        van = false
        g.tags.each do |t|
          if selected_tags.include?(t.name)
            van = true
          end
        end
        if van
          array.push g
        end
      end
    end
    array
  end

  def set_selected_floors
    if !params[:selected_floors].nil?
      selected_floors = params[:selected_floors].split('#')
    elsif !params[:floors].nil?
      selected_floors = params[:floors] 
    end
    selected_floors
  end
  
  def set_selected_tags
    prev_tags_arr = Array.new
    prev_tags_str = ""
    if !params[:prev_tags].nil? && params[:prev_tags] != ""
      prev_tags_str = prev_tags_str + params[:prev_tags]
    end
    if !params[:selected_tags].nil? && params[:selected_tags] != ""
      prev_tags_str = prev_tags_str + "&&" + params[:selected_tags]
    end
    i = 0
    prev_tags_str.split("&&").each do |s|
      prev_tags_arr[i] = s.split("#")
      i += 1
    end
    return prev_tags_arr, prev_tags_str
  end

  def get_selected_goods    
    if params[:order_by] == "floor"
      goods = order_by_floor()
    else
      if params[:order_by].nil? || params[:order_by] == "" || params[:order_direction] == ""
        order_by = "created_at"
        order_direction = "desc"
      else
        order_by = params[:order_by]
        order_direction = params[:order_direction]
      end
      goods = Good.with_attached_photo.all.order(order_by => order_direction).includes(:tags)
    end

    if !params[:prev_tags].nil? && params[:prev_tags] != ""
      if !params[:deleted_tag].nil? && params[:deleted_tag] != ""
        params[:prev_tags].slice! (params[:deleted_tag] + "#")
        params[:prev_tags].slice! ("#" + params[:deleted_tag])
        params[:prev_tags].slice! params[:deleted_tag]
      end
      params[:prev_tags].split("&&").each do |t|
        goods = filter_tag(goods, t)
      end
    end
    goods = filter_tag(goods)    
    goods_from_goods = searched_goods(goods)
    goods_from_tags = searched_tags(goods)
    goods = (goods_from_goods + goods_from_tags).uniq {|t| t.id }

    levels = set_levels(goods)
    goods = filter_floor(goods)
    
    return goods, levels
  end

  def searched_tags(goods)
    searched_tags = ""
    if !params[:searched_phrase].nil?
      Tag.all.each do |t|
          if t.name.include?(params[:searched_phrase])
            searched_tags = searched_tags + "#" + t.name
          end
      end
    end
    filtered = Array.new
    unless searched_tags == ""
      filtered = filter_tag(goods, searched_tags)
    end
    return filtered
  end

  def searched_goods(goods)
    if params[:searched_phrase].nil? || params[:searched_phrase] == ""
      good_array = goods
    else
      good_array = Array.new
      goods.each do |g|
        if g.name.downcase == params[:searched_phrase]
          good_array.unshift(g)
        elsif g.name.downcase.include?(params[:searched_phrase])
          good_array << g
        end
      end
    end
    return good_array
  end

  def set_tags(goods, prev_tags_arr)
    if search_params_nil
      tags_o = Tag.where('number >= ?', 1).order(number: :desc, name: :asc)
    else
      tags = Array.new
      goods.each do |g|
        g.tags.each do |t|
          tags << t.name
        end
      end
      tags = tags.uniq
      prev_tags_arr.each do |t_arr|
        tags = tags - t_arr
      end
      tags_o = Array.new
      tags.each do |t|
        num = 0
        goods.each do |g|
          unless g.tags.select { |s| s.name == t}.first.nil?
            num += 1
          end
        end
        tags_o << Tag.new(name: t, number: num)
      end
      tags_o.sort_by!(&:name).reverse!
      tags_o.sort_by!(&:number).reverse!
    end
    tags_o
  end

  def set_levels(goods)
    levels = Level.where('good_number != ?', 0)
    unless search_params_nil
      levels_arr = Array.new
      levels.each do |l|
        num = 0
        goods.each do |g|
          if g.floor == l.number
            num += 1
          end
        end
        if num > 0
          levels_arr << Level.new(number: l.number, good_number: num)
        end
      end
      levels = levels_arr
    end
    
    return levels.sort_by!(&:number)
  end

  def search_params_nil
    if params[:searched_phrase] == "" && params[:searched_phrase].nil? &&
       params[:prev_tags] == "" && params[:prev_tags].nil &&
       params[:selected_tags] == "" && params[:selected_tags]
       
       return true
    else
      return false
    end
  end

  def order_by_floor
    good = Array.new
    Good.with_attached_photo.all.order(created_at: :desc).includes(:tags).each do |g|
      good << g
    end 
    array = Array.new
    user_level = current_user.roomnumber / 100
    i = 0
    while i < good.length do
      if good[i].floor == user_level
        array << good[i]
        good.delete_at(i)
        i -= 1
      end
      i += 1
    end
    j = user_level - 1
    k = user_level + 1

    n = (user_level - 10).abs + 10
    for l in 1..n
      while j > 0 do
        i = 0
        while i < good.length do
          if good[i].floor == j
            array << good[i]
            good.delete_at(i)
            i -= 1
          end
          i += 1
        end
        j -= 1
        break
      end
      while k <= 20 do
        i = 0
        while i < good.length do
          if good[i].floor == k
            array << good[i]
            good.delete_at(i)
            i -= 1
          end
          i += 1
        end
        k += 1
        break
      end
    end
    array
  end


end
