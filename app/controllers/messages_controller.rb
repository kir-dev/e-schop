# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end

  def index
    @messages = @conversation.messages
    @messages.where('user_id != ? AND read = ?', current_user.id, false).update_all(read: true)
    @message = @conversation.messages.new
    if @messages.count == 0
      redirect_to action: 'new', conversation_id: @conversation.id
    else
      redirect_to controller: 'conversations', action: 'index', conversation_id: @conversation.id
    end
  end

  def new
    @conversation = Conversation.find_by_id(params[:conversation_id])
    @message = @conversation.messages.new
  end

  def create
    @message = @conversation.messages.new(message_params)
    @message.user = current_user

    if @message.save
      @conversation.update_attributes(updated_at: Time.current)
      redirect_to action: 'index', controller: 'conversations', conversation_id: @conversation.id
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end
