class ChatSession < ApplicationRecord
  has_many :chat_messages, dependent: :destroy
end
