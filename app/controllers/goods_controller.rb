class GoodsController < ApplicationController
  def landing; end

  def index
    getSelectedGoods
  end

  def getSelectedGoods
    @goods = Good.all.order(name: :asc, created_at: :desc)
    unless (params[:post].blank? || params[:post][:category_id].blank?)
      @goods = @goods.select{ |g| g.category_id == params[:post][:category_id].to_i }
    end
    unless params[:scearched_prase].blank?
      @goods = @goods.select { |g| g.name.downcase.include?(params[:scearched_prase].downcase) }
      logger.debug
    end
  end

  def show
    @good = Good.find(params[:id])
    @user = User.find_by_id(@good.seller_id)
    @order = Good.new
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
      redirect_to controller: 'users', action: 'good_show', id: @good.id
    else
      render action: 'new'
    end
  end

  def delete_num
    @good = Good.find_by_id(params[:id])
    @number = Good.new
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
    @goods = Good.all
  end

  def food
    @goods = Good.where(category_id: 1)
  end

  def drink
    @goods = Good.where(category_id: 2)
  end

  def else
    @goods = Good.where(category_id: 3)
  end

  def search
    @categories = Category.all
    getSelectedGoods
  end

  private

  def good_params
    params.require(:good).permit(:name, :price, :text, :description, :number, :category_id)
  end

  def product_params
    params.require(:good).permit(:name, :photo, :category_id)
  end
end
