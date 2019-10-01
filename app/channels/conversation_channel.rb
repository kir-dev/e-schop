class ConversationChannel < ApplicationCable::Channel
  def subscribed
    conversation = Conversation.find(params[:id])
    stream_for conversation
  end

  def unsubscribed
    stop_all_streams
  end
end