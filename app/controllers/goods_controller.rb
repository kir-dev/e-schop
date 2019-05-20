class GoodsController < ApplicationController
  before_action :check_good_id, only: [:show, :delete_num, :destroy, :to_cart,
                  :back_from_cart, :to_bought, :back_from_bought, :copy]

  def landing; end

  def index
    @categories = Category.all
    getSelectedGoods
  end

  def getSelectedGoods
    @goods = Good.all
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
    @good = Good.new(good_params)
    @good.seller_id = current_user.id
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

  private

  def good_params
    params.require(:good).permit(:name, :price, :text, :description, :category_id, :number, :photo)
  end
end