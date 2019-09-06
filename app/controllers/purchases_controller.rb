# frozen_string_literal: true

class PurchasesController < ApplicationController
  def to_cart
    @purchase = Purchase.new(buyer_id: current_user.id, good_id: params[:id],
                             number: params[:good][:number])
    good = Good.find(params[:id])

    body = current_user.name + ' megrendelt a(z) ' + good.name + ' termékedből ' +
                    @purchase.number.to_s + " darabot.\n" + Time.current.to_s(:db)
    seller = User.find_by_id(good.seller_id)
    if @purchase.number.nil? || @purchase.number == 0
      flash[:alert] = "Nem vásároltál terméket"
      redirect_to action: 'show', controller: 'goods', id: params[:id]
    elsif @purchase.number < good.number && @purchase.save
      good.update_attributes(number: good.number - @purchase.number)
      send_message(body: body, receiver_id: seller.id)
      UserMailer.with(receiver: seller, purchase_id: @purchase.id,
                      good_id: good.id, body: @message.body).to_sold_goods_mail.deliver_now
      flash[:notice] = "Az eladót üzenetben értesítettük a rendelésről."
      redirect_to action: 'my_cart', controller: 'users'
    elsif @purchase.number == good.number && @purchase.save
      send_message(body: body, receiver_id: seller.id)
      UserMailer.with(receiver: seller, purchase_id: @purchase.id,
                      good_id: good.id, body: @message.body).to_sold_goods_mail.deliver_now
      flash[:notice] = "Az eladót üzenetben értesítettük a rendelésről." 
      good.update_attributes(number: 0)
      good.destroy
      redirect_to action: 'my_cart', controller: 'users'
    else
      flash[:alert] = t(:not_enough_good)
      redirect_to action: 'show', controller: 'goods', id: params[:id]
    end
  end

  def back_from_cart
    @purchase = Purchase.find_by_id(params[:id])
    good = Good.with_deleted.find(@purchase.good_id)
    good.number += @purchase.number
    good.update_attributes(deleted_at: nil)
    @purchase.destroy

    body = current_user.name + ' lemondta a rendelést a(z) ' + good.name + " termékedről.\n" + Time.current.to_s(:db) 
    seller = User.find_by_id(good.seller_id)
    send_message(body: body, receiver_id: seller.id)
    UserMailer.with(receiver: seller, body: body).to_sold_goods_mail.deliver_now
    flash[:notice] = t(:back_from_cart)
    redirect_to action: 'my_cart', controller: 'users'
  end

  def delete
    @purchase = Purchase.find(params[:id])
    body = "Az eladó, " + current_user.name + " jóváhagyta a termék kifizetését. " + Time.current.to_s(:db) 
    buyer = User.find_by_id(@purchase.buyer_id)
    send_message(body: body, receiver_id: buyer.id)
    UserMailer.with(receiver: buyer, body: body).purchase_paid_mail.deliver_now
    @purchase.destroy
    redirect_to action: 'sold_goods', controller: 'users'
  end

  private

  def send_message(receiver_id:, body:)
    if Conversation.between(current_user.id, receiver_id).present?
      @conversation = Conversation.between(current_user.id, receiver_id).first
    else
      @conversation = Conversation.create!(sender_id: current_user.id, receiver_id: receiver_id)
    end
    @message = @conversation.messages.new
    @message.body = body
    @message.user = current_user
    @conversation.update_attributes(updated_at: Time.current) if @message.save
  end
end
