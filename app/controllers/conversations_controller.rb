class ConversationsController < ApplicationController
  def index
    @conversations = current_user.mailbox.conversations
  end

  def show
    @conversation = current_user.mailbox.conversations.find(params[:id])
    @partner = (@conversation.participants - [current_user])[0]
    @receipts = @conversation.receipts_for(current_user).order(created_at: :asc)

    respond_to do |format|
      format.js { render layout: false }
    end
  end

  def new
    @recipients = User.all - [current_user]

    respond_to do |format|
      format.js { render layout: false }
    end
  end

  def create
    if params[:subject].empty?
      flash.now[:alert] = t(:no_subject)
    else
      recipient = User.find(params[:user_id])
      current_user.send_message(recipient, params[:body], params[:subject])
      redirect_to conversations_path(current_user)
    end
  end
end
