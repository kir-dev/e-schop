# frozen_string_literal: true

class FilterController < ApplicationController
  include GoodsHelper
  include ParamsHelper
  def index
    
    copy_params_to_shash
    get_params_from_shash
    byebug

    @goods, @levels = get_selected_goods
    @order_by = params[:order_by]
    @order_direction = params[:order_direction]

    @selected_floors = set_selected_floors
    @prev_tags_arr, @prev_tags_str = set_selected_tags
    @searched_phrase = params[:searched_phrase]

    @products = Product.with_attached_photo.all
    @sellers = find_sellers_for_goods(@goods)
    @tags = set_tags(@goods, @prev_tags_arr)
    @goods = @goods.paginate(page: params[:page], per_page: 25)
      # @recommendtaions = get_recommendations(9) unless current_user.nil?
    end

    def delete_selected
      params[:prev_tags]=""
      delete_params_from_shash
      redirect_to filter_index_get_path
    end
  private

 

  def filter_floor(goods)
    filtered_goods = []

    if params[:selected_floors].nil? || params[:selected_floors] == ''
      if params[:floors].nil?
        filtered_goods = goods
      else
        selected_floors = params[:floors]
      end
    else
      selected_floors = params[:selected_floors].split('#')
    end

    unless selected_floors.nil?
      goods.each do |g|
        filtered_goods.push g if selected_floors.include?(g.floor.to_s)
      end
    end

    filtered_goods
  end

  def filter_tag(goods, searched_tags = '')
    array = []
    selected_tags_s = params[:selected_tags]
    selected_tags_s = searched_tags if searched_tags != ''
    if selected_tags_s.nil? || selected_tags_s == ''
      array = goods
    else
      selected_tags = selected_tags_s.split('#')
    end
    unless selected_tags.nil?
      goods.each do |g|
        van = false
        g.tags.each do |t|
          van = true if selected_tags.include?(t.name)
        end
        array.push g if van
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
    prev_tags_arr = []
    prev_tags_str = ''
    if !params[:prev_tags].nil? && params[:prev_tags] != ''
      prev_tags_str += params[:prev_tags]
    end
    if !params[:selected_tags].nil? && params[:selected_tags] != ''
      prev_tags_str = prev_tags_str + '&&' + params[:selected_tags]
    end
    prev_tags_str.split('&&').each_with_index do |s, i|
      prev_tags_arr[i] = s.split('#')
    end
    [prev_tags_arr, prev_tags_str]
  end

  def selected_goods
    if params[:order_by] == 'floor'
      goods = order_by_floor
    else
      if params[:order_by].nil? || params[:order_by] == '' || params[:order_direction] == ''
        order_by = 'created_at'
        order_direction = 'desc'
      else
        order_by = params[:order_by]
        order_direction = params[:order_direction]
      end
      goods = Good.with_attached_photo.all.order(order_by => order_direction).includes(:tags)
    end

    if !params[:prev_tags].nil? && params[:prev_tags] != ''
      if !params[:deleted_tag].nil? && params[:deleted_tag] != ''
        params[:prev_tags].slice! "#{params[:deleted_tag]}#"
        params[:prev_tags].slice! "##{params[:deleted_tag]}"
        params[:prev_tags].slice! params[:deleted_tag]
      end
      params[:prev_tags].split('&&').each do |t|
        goods = filter_tag(goods, t)
      end
    end
    goods = filter_tag(goods)
    goods_from_goods = searched_goods(goods)
    goods_from_tags = searched_tags(goods)
    goods = (goods_from_goods + goods_from_tags).uniq(&:id)

    levels = set_levels(goods)
    goods = filter_floor(goods)

    [goods, levels]
  end

  def searched_tags(goods)
    searched_tags = ''
    unless params[:searched_phrase].nil?
      Tag.all.each do |t|
        if t.name.include?(params[:searched_phrase])
          searched_tags = searched_tags + '#' + t.name
        end
      end
    end
    filtered = []
    filtered = filter_tag(goods, searched_tags) unless searched_tags == ''
    filtered
  end

  def searched_goods(goods)
    if params[:searched_phrase].nil? || params[:searched_phrase] == ''
      good_array = goods
    else
      good_array = []
      goods.each do |g|
        if g.name.downcase == params[:searched_phrase]
          good_array.unshift(g)
        elsif g.name.downcase.include?(params[:searched_phrase])
          good_array << g
        end
      end
    end
    good_array
  end

  def set_tags(goods, prev_tags_arr)
    if search_params_nil
      return Tag.where('number >= ?', 1).order(number: :desc, name: :asc)
    end

    tags = []
    goods.each do |g|
      g.tags.each do |t|
        tags << t.name
      end
    end
    tags = tags.uniq
    prev_tags_arr.each do |t_arr|
      tags -= t_arr
    end
    tags_o = []
    tags.each do |t|
      num = 0
      goods.each do |g|
        num += 1 unless g.tags.select { |s| s.name == t }.first.nil?
      end
      tags_o << Tag.new(name: t, number: num)
    end
    tags_o.sort_by!(&:name).reverse!
    tags_o.sort_by!(&:number).reverse!
  end

  def set_levels(goods)
    levels = Level.where('good_number != ?', 0)
    unless search_params_nil
      levels_arr = []
      levels.each do |l|
        num = 0
        goods.each do |g|
          num += 1 if g.floor == l.number
        end
        levels_arr << Level.new(number: l.number, good_number: num) if num > 0
      end
      levels = levels_arr
    end

    levels.sort_by!(&:number)
  end

  def search_params_nil
    if params[:searched_phrase] == '' && params[:searched_phrase].nil? &&
       params[:prev_tags] == '' && params[:prev_tags].nil &&
       params[:selected_tags] == '' && params[:selected_tags]

      true
    else
      false
    end
  end

  def order_by_floor
    good = []
    Good.with_attached_photo.all.order(created_at: :desc).includes(:tags).each do |g|
      good << g
    end
    array = []
    user_level = current_user.roomnumber / 100
    i = 0
    while i < good.length
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
    (1..n).each do |_l|
      while j > 0
        i = 0
        while i < good.length
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
      while k <= 20
        i = 0
        while i < good.length
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
