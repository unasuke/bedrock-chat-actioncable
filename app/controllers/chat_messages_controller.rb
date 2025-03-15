class ChatMessagesController < ApplicationController
  def create
    @chat_message = ChatMessage.new(params.expect(chat_message: [:chat_session_id, :role, :content]))
    if @chat_message.save
      # TODO
      RetrieveAnswerFromAgentJob.set(wait: 2.seconds).perform_later(@chat_message.id)
    else
      # TODO
    end
  end
end
