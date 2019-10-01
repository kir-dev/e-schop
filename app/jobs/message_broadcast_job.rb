class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(conversation, body)
    ConversationChannel.broadcast_to conversation, body
  end
end
