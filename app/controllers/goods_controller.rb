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
 
        @good.save
        redirect_to @good
    end

    private
        def good_params
          params.require(:good).permit(:name, :price, :text,:description,:seller_id)
        end

end
