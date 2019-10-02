# frozen_string_literal: true

class ProductsController < ApplicationController
  def choose
    @products = Product.all
    @good = Good.new
  end

  def new_from_product
    @product = Product.find_by_id(params[:good][:product_id])
    @good = Good.new(name: @product.name, category_id: @product.category_id)
    @tag_array = Array.new
    @product.tags.each do |t|
      @tag_array.push t.name
    end
    @tag_array.shift    
    @main_tags = Tag.where(category: true)
  end

  def create_from_product
    product = Product.find_by_id(params[:product_id])
    @good = Good.new(good_params)
    @good.seller_id = current_user.id
    unless params[:good][:photo].nil?
      product = Product.new(product_params)
      product.save
    end
    @good.product_id = product.id
    if @good.save
      level_num_update(1, current_user.roomnumber)
      add_good_tags_from_params(@good)
      tag_num_update(1, @good.tags)
      redirect_to controller: 'users', action: 'good_show', id: @good.id
    else
      render action: 'new'
    end
  end
  
  def search
    term = params[:product_search].downcase
    @tags = Tag.select { |tag| tag.name.include?(term) }
    @products = Product.select { |product| product.name.downcase.include?(term)|| (@tags&product.tags).length>0}
    
    respond_to do |format|
      format.html {
        render "choose"
      }
      format.json do
        @products
      end
    end
   

    
  end

  private

  def good_params
    params.require(:good).permit(:name, :price, :text, :description, :number, :category_id)
  end

  def product_params
    params.require(:good).permit(:name, :photo, :category_id)
  end

  def add_good_tags_from_params(good)
    return if good.nil?

    selected_tags = params[:selected_tags].split('#')
    selected_tags.unshift(params[:good][:main_tag])
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
end
