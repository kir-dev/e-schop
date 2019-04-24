class MessagesController < ApplicationController
    before_action :set_conversation
    
    def new

    end

    def create
        receipt = User.find_by_id(session[:user_id]).reply_to_conversation(@conversation, params[:body])
        redirect_to conversation_path(receipt.conversation)
    end
private
    def set_conversation
        @conversation = User.find_by_id(session[:user_id]).mailbox.conversations.find(params[:conversation_id])
    end

end