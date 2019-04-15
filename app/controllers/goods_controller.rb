class GoodsController < ApplicationController

  def landing

  end

    def index
        @goods = Good.all
      end

    def show
        @good = Good.find(params[:id])
      end

    def new
    end
    
    def create
        @good = Good.new(good_params)
 
        if @good.save
          redirect_to @good
        else
          render :action => 'new'
        end
    end

    def destroy
        @good = Good.find(params[:id])
        @good.destroy
        redirect_to :action => 'index'
    end

    private
        def good_params
          params.require(:good).permit(:name, :price, :text, :description, :seller_id, :category_id)
        end

end
