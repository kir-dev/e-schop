# frozen_string_literal: true

class PurchasesController < ApplicationController
  def to_cart
    @purchase = Purchase.new(buyer_id: current_user.id, good_id: params[:id],
                             number: params[:good][:number])
    good = Good.find(params[:id])

    if Conversation.between(current_user.id, good.seller_id).present?
      @conversation = Conversation.between(current_user.id, good.seller_id).first
    else
      @conversation = Conversation.create!(sender_id: current_user.id, receiver_id: good.seller_id)
    end
    @message = @conversation.messages.new
    @message.body = current_user.name + ' megrendelt a(z) ' + good.name + ' termékedből ' +
                    @purchase.number.to_s + " darabot.\n" + Time.current.to_s(:db)
    @message.user = current_user

    if @purchase.number < good.number && @purchase.save
      @conversation.update_attributes(updated_at: Time.current) if @message.save
      good.update_attributes(number: good.number - @purchase.number)
      redirect_to action: 'my_cart', controller: 'users'
    elsif @purchase.number == good.number && @purchase.save
      @conversation.update_attributes(updated_at: Time.current) if @message.save
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

    if Conversation.between(current_user.id, good.seller_id).present?
      @conversation = Conversation.between(current_user.id, good.seller_id).first
    else
      @conversation = Conversation.create!(sender_id: current_user.id, receiver_id: good.seller_id)
    end
    @message = @conversation.messages.new
    @message.body = current_user.name + ' lemondta a rendelést a(z) ' + good.name + " termékedről.\n" + Time.current.to_s(:db)
    @message.user = current_user
    @conversation.update_attributes(updated_at: Time.current) if @message.save

    redirect_to action: 'my_cart', controller: 'users'
  end

  def delete
    @purchase = Purchase.find(params[:id])
    @purchase.destroy
    flash[:notice] = 'Jeleztet a termék kifizetését'
    redirect_to action: 'sold_goods', controller: 'users'
  end
end
