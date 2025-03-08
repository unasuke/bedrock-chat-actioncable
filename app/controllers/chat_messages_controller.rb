class ChatMessagesController < ApplicationController
  def create
    if params[:chat_message][:chat_session_id].present?
    else
      # chat_session = ChatSession.new
    end
  end
end
