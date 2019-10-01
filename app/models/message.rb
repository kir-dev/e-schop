# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user
  validates_presence_of :body, :conversation_id, :user_id

  # after_create_commit {MessageBroadcastJob.perform_now self}

  private

  def message_time
    created_at.strftime('%d/%m/%y at %l:%M %p')
  end
end
