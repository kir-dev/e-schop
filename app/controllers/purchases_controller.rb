class PurchasesController < ApplicationController
  def to_cart
    @purchase = Purchase.new(buyer_id: current_user.id, good_id: params[:id],
                            number: params[:good][:number])
    good = Good.find(params[:id])
    if @purchase.number < good.number && @purchase.save
      good.update_attributes(number: good.number - @purchase.number)
      redirect_to action: 'my_cart', controller: 'users'
    elsif @purchase.number == good.number && @purchase.save
      good.update_attributes(number: 0)
      good.destroy
      redirect_to action: 'my_cart', controller: 'users'
    else
      flash[:alert] = t(:not_enough_good)
      redirect_to action: 'show', controller: 'goods', id: params[:id]
    end
  end

  def back_from_cart
    @purchase = Purchase.find(params[:id])
    good = Good.with_deleted.find(@purchase.good_id)
    good.number += @purchase.number
    good.update_attributes(deleted_at: nil)
    flash[:notice] = t(:back_from_cart)
    @purchase.destroy
    redirect_to action: 'my_cart', controller: 'users'
  end

  def delete
    @purchase = Purchase.find(params[:id])
    @purchase.destroy
    flash[:notice] = 'Jeleztet a termék kifizetését'
    redirect_to action: 'sold_goods', controller: 'users'
  end
end
