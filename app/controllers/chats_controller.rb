class ChatsController < ApplicationController
  def index
    @chats = ChatSession.all.order(created_at: :desc)
    @new_chat_message = ChatMessage.new
  end

  def show
    @chat = ChatSession.find(params[:id])
  end
end
