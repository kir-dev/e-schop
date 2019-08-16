class GoodsController < ApplicationController
 include ProductsHelper
before_action :force_json, only: :autocomplete

  def index
    getSelectedGoods
    @products=Product.with_attached_photo.all()
    unless current_user.nil?
      @recommendtaions= get_recommendations(9)
    end
  end

  def getSelectedGoods
    @goods = Good.with_attached_photo.all.order(name: :asc, created_at: :desc)
    unless (params[:post].blank? || params[:post][:category_id].blank?)
      @goods = @goods.select{ |g| g.category_id == params[:post][:category_id].to_i }
    end
    unless params[:scearched_prase].blank?
      @goods = @goods.select { |g| g.name.downcase.include?(params[:scearched_prase].downcase) }
      logger.debug
    end
  end

  def show
    @good = Good.with_attached_photo.find(params[:id])
    @product= Product.with_attached_photo.find(params[:id])
    @user = User.find_by_id(@good.seller_id)
    @order = Good.new

    unless current_user.nil?
     add_good_tags_to_user_intrests(@good)
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
    add_good_tags_from_params(@good)
 
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
    byebug
    @goods = Good.with_attached_photo.limit(8)
    @products=get_proucts_for_goods(@goods)
  end

  def food
  

    @goods = Good.with_attached_photo.where(category_id: 1)
    @products=get_proucts_for_goods(@goods)
  end

  def drink
    @goods = Good.with_attached_photo.where(category_id: 2)
    @products=get_proucts_for_goods(@goods)
  end

  def else
    @goods = Good.with_attached_photo.where(category_id: 3)
    @products=get_proucts_for_goods(@goods)
  end

  def search
    @categories = Category.all
    getSelectedGoods
  end

  def add_good_tags_from_params(good)
    selected_tags=params[:selected_tags].split("#")
    
    tags=Tag.all
    selected_tags.each do |tag|
      if  tags.any?{|t| t.name == tag}
        good.tags<<tags.find{|t| t.name == tag}
      else
        new_tag=  Tag.create(name:tag)
        good.tags<<new_tag
      end
    end


  end

  def get_recommendations(recommendations_count)
    
    recommendation_per_tag_number=2
    
    recommendations=[]
    user_favourite_tags.each do|tag|
      
      recommendations_per_tag= Good.limit(recommendation_per_tag_number).
      select{|good| ( (good.tags.include?(tag))&&(!recommendations.include?(good)))}
      recommendations_count-=recommendations_per_tag.size
      recommendations_per_tag.each do|rec|
        recommendations.push(rec)
      end
    end
    recommendations_from_other= Good.limit(recommendations_count).select{|good| !good.tags.include?(user_favourite_tags) &&(!recommendations.include?(good))}
    recommendations_from_other.each do|rec|
      recommendations.push(rec)
    end
    recommendations
       
  end
 

  def user_favourite_tags
    
    top_intrests= current_user.intrests.order(rate: :desc).limit(3)
    favourite_tags=[]
    top_intrests.each do|intrest|
      favourite_tags.push(intrest.tag)
    end
    favourite_tags
  end

  def total_intrest_rate_in_tag(tag)
    total_intrest_rate=0
    
    User.all.each do|user|
      user_intrest=user.intrests.find{|intrest| intrest.tag==tag}
      unless user_intrest.nil?
        total_intrest_rate+=user_intrest.rate
      end
    end

    total_intrest_rate
  end

  def autocomplete
    tag_name =params[:q].downcase
    @tags=Tag.select{|tag| tag.name.include?(tag_name)}
   
    respond_to do |format|
      format.json 
    end
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
      intrest_in_tag=  current_user.intrests.find{|intrest| intrest.tag==tag}
      if intrest_in_tag.nil?
        new_intrest=current_user.intrests.create(rate: 1)
        new_intrest.tag=tag
        new_intrest.save
      else
        intrest_in_tag.rate+=1
        intrest_in_tag.save
      end
    end  
  end  
  
  def force_json
    request.format= :json 
  end
 


  

end
