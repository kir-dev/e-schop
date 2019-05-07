class RecordsController < ApplicationController
    def create
        @record = Record.find_by_name(params[:name].downcase)
        if @record == nil
            @record = Record.new(:name => params[:name].downcase, :avg_price => params[:price],
                                 :num => 1, :category_id => params[:category_id])
            @record.save
        else
            avg = (@record.avg_price * @record.num + params[:price].to_f) / (@record.num.to_f + 1)
            @record.update_attributes(:num => @record.num + 1, :avg_price => avg)
        end
        redirect_to :controller => 'users', :action => 'good_show', :id => params[:id]
    end
end
