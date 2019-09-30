class ConversationChannel < ApplicationCable::Channel
  def subscribed
    conversation = Conversation.find(params[:id])
    stream_for conversation
    # stream_from "conversation_channel_#{params[:id]}"
  end
end