class ConversationsController < ApplicationController

    def index
        @conversations = User.find_by_id(session[:user_id]).mailbox.conversations
    end

    def show
        @conversation = User.find_by_id(session[:user_id]).mailbox.conversations.find(params[:id])
    end
        
    def new
        @recipients = User.all - [User.find_by_id(session[:user_id])]
    end

    def create
        recipient = User.find(params[:user_id])
        receipt = User.find_by_id(session[:user_id]).send_message(recipient,
                                                        params[:body], params[:subject])
        redirect_to conversations_path(receipt.conversation)
    end
end
