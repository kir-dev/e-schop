class GoodsController < ApplicationController
    before_action :check_good_id, only: [:show, :delete_num, :destroy, :to_cart,
                                    :back_from_cart, :to_bought, :back_from_bought, :copy]

    def landing

    end

    def index
      @categories= Category.all
      getSelectedGoods
    end

    def getSelectedGoods
      @goods= Good.all    
      if !(params[:post].blank?||params[:post][:category_id].blank?)
      @goods= @goods.select{|g| g.category_id==params[:post][:category_id].to_i}
      end        
      if !params[:scearched_prase].blank?
        @goods= @goods.select{ |g| g.name.downcase.include?(params[:scearched_prase].downcase) }
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
        @good.seller_id = session[:user_id]
        if @good.save
          redirect_to :controller => 'users', :action => 'good_show', :id => @good.id
        else
          render :action => 'new'
        end
    end

    def delete_num
      @good = Good.find_by_id(params[:id])
      @number = Good.new
    end

    def destroy
      @good = Good.find(params[:id])
      if params[:good] == nil
        @good.destroy
        redirect_to :controller => 'users', :action => 'my_goods'
      else
        number = Good.new(delete_params)
        if @good.number > number.number
          new_num = @good.number - number.number
          @good.update_attributes(:number => new_num)
          redirect_to :controller => 'users', :action => 'good_show', :id => @good.id
        else
          @good.destroy
          redirect_to :controller => 'users', :action => 'my_goods'
        end
      end
    end

    def to_cart
      good = Good.find(params[:id])
      error = false
      if good.seller_id === session[:user_id]
        error = true
      elsif good.update_attributes(:buyer_id => session[:user_id])    
        error = false      
      else
          error = true
      end
      if error == false
        redirect_to :controller => 'users', :action => 'my_cart'
      else 
        redirect_to :controller => 'goods', :action => 'index'
      end
    end

    def back_from_cart
      if Good.find(params[:id]).destroy
        redirect_to :controller => 'users', :action => 'my_cart'
      else
        redirect_to :controller => 'users', :action => 'my_cart'
      end
    end

    def to_bought
      recipient = User.find(params[:user_id])
      receipt = User.find_by_id(session[:user_id]).send_message(recipient,
                params[:body], params[:subject])

      @good = Good.find(params[:id])
      original = Good.find_by_id(@good.original)
      if @good.number < original.number
        new_number = original.number - @good.number
        original.update_attributes(:number => new_number)
        @good.update_attributes(:bought => true)
        redirect_to :controller => 'users', :action => 'bought_goods', :id => @good.id
      elsif @good.number == original.number
        @good.update_attributes(:bought => true)
        original.destroy
        redirect_to :controller => 'users', :action => 'bought_goods', :id => @good.id
      else
        redirect_to :controller => 'users',:action => 'my_cart'
      end
    end

    def back_from_bought
      good = Good.find(params[:id])
      goods = Good.all
      exists = false
      found = Good.new
      goods.each do |g|
        if g.buyer_id == nil && !g.bought  
          if !exists && g.name == good.name && g.seller_id == good.seller_id && g.price == good.price
            exists = true
            found = g
          end
        end
      end  
      if exists
        new_num = found.number + good.number
        found.update_attributes(:number => new_num)
        good.destroy
      elsif !exists
        good.update_attributes(:buyer_id => nil, :bought => nil, :original => nil)
      end
      redirect_to :action => 'bought_goods', :controller => 'users'
    end

    def copy
      copied = Good.find(params[:id])
      order = Good.new(copy_param)
      @good = Good.new
      @good.name = copied.name
      @good.category_id = copied.category_id
      @good.description = copied.description
      @good.seller_id = copied.seller_id
      @good.price = copied.price
      @good.original = copied.id

      @good.number = order.number
      if  @good.seller_id != session[:user_id] && @good.number <= copied.number && @good.save
        redirect_to :action => 'to_cart' , :id => @good.id 
      else
        redirect_to :action => 'show', :id => copied.id
      end
    end

    private
        def good_params
          params.require(:good).permit(:name, :price, :text, :description, :category_id, :number, :photo)
        end
        def copy_param
          params.require(:good).permit(:number)
        end

        def delete_params
          params.require(:good).permit(:number)
        end
end