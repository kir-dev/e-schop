# frozen_string_literal: true

class ConversationsController < ApplicationController
  before_action do
    @conversations = Conversation.where('sender_id = ? OR receiver_id = ?', current_user.id, current_user.id)
    @conversations.each do |c|
      number = c.messages.count
      c.destroy if number == 0
    end
  end

  def index
    @conversations = Conversation.where('sender_id = ? OR receiver_id = ?', current_user.id, current_user.id).order(updated_at: :desc)
    @conversation = if params[:conversation_id].nil?
                      @conversations.first
                    else
                      Conversation.find_by_id(params[:conversation_id])
                    end
    unless @conversation.nil?
      @messages = @conversation.messages.order(created_at: :desc)
      @messages.where('user_id != ? AND read = ?', current_user.id, false).update_all(read: true)
      @message = @conversation.messages.new
    end
  end

  def create
    if Conversation.between(params[:sender_id], params[:receiver_id]).present?
      @conversation = Conversation.between(params[:sender_id], params[:receiver_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end

    redirect_to conversation_messages_path(@conversation)
  end

  def search
    term = params[:q].downcase
    @users = User.select { |user| user.name.downcase.include?(term) }
    respond_to do |format|
      format.html {}
      format.json do
        @users = @users.take(5)
      end
    end
  end

  def view
    render plain: params[:q].inspect
  end

  private

  def conversation_params
    params.permit(:sender_id, :receiver_id)
  end
end
