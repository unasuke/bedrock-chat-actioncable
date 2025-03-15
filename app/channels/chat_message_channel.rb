class ChatMessageChannel < ApplicationCable::Channel
  def subscribed
    chat_session = ChatSession.find(params[:id])
    stream_for chat_session
  end
end
