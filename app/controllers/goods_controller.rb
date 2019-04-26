class GoodsController < ApplicationController

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
    end

    def new
      @categories = Category.all
    end
    
    def create
        @good = Good.new(good_params)
        @good.seller_id = session[:user_id]
        if @good.save
          redirect_to @good
        else
          render :action => 'new'
        end
    end

    def destroy
        @good = Good.find(params[:id])
        @good.destroy
        redirect_to :controller => 'users', :action => 'my_goods'
    end

    def to_cart
      recipient = User.find(params[:user_id])
      receipt = User.find_by_id(session[:user_id]).send_message(recipient,
                params[:body], params[:subject])

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
      if Good.find(params[:id]).update_attributes(:buyer_id => nil)
        redirect_to :controller => 'users', :action => 'my_cart'
      else
        redirect_to :controller => 'users', :action => 'my_cart'
      end
    end

    private
        def good_params
          params.require(:good).permit(:name, :price, :text, :description, :category_id)
        end
end
