class ChatMessagesController < ApplicationController
  def create
    @chat_message = ChatMessage.new(params.expect(chat_message: [:chat_session_id, :role, :content]))
    if @chat_message.save
      # TODO
    else
      # TODO
    end
  end
end
