class MessagesController < ApplicationController
  before_action :set_conversation
  def new; end

  def create
    @receipt = current_user.reply_to_conversation(@conversation, params[:body])
    @message = @receipt.message.body
    @sent_time = @receipt.message.created_at.strftime('%Y. %m. %d. %H:%M')
    
    respond_to do |format|
      format.js { render layout: false }
    end
  end

  private

  def set_conversation
    @conversation = current_user.mailbox.conversations.find(params[:conversation_id])
  end
end
