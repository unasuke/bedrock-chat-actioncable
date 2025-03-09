class ChatsController < ApplicationController
  def index
    @chat_sessions = ChatSession.all.order(created_at: :desc)
  end

  def show
    @chat_sessions = ChatSession.all.order(created_at: :desc)
    @chat_session = ChatSession.eager_load(:chat_messages).find(params[:id])

    if @chat_session.chat_messages.size == 1
      # first question
    end
  end

  def create
    @chat_session = ChatSession.new(title: params[:initial_message], bedrock_session_id: "")
    chat_message = ChatMessage.new(role: "user", content: params[:initial_message])
    if @chat_session.save
      redirect_to chat_path(@chat_session)
    else
      redirect_to chats_path
    end
  end
end
