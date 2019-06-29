class ProductsController < ApplicationController
  def choose
    @products = Product.all
    @good = Good.new
  end

  def new_from_product
    @product = Product.find_by_id(params[:good][:product_id])
    @good = Good.new(name: @product.name, category_id: @product.category_id)
    @categories = Category.all
  end

  def create_from_product
    product = Product.find_by_id(params[:product_id])
    @good = Good.new(good_params)
    @good.seller_id = current_user.id
    if !params[:good][:photo].nil?
      product = Product.new(product_params)
      product.save
    end
    @good.product_id = product.id
    if @good.save
      redirect_to controller: 'users', action: 'good_show', id: @good.id
    else
      render action: 'new'
    end
  end

  private

  def good_params
    params.require(:good).permit(:name, :price, :text, :description, :number, :category_id)
  end

  def product_params
    params.require(:good).permit(:name, :photo, :category_id)
  end
end
