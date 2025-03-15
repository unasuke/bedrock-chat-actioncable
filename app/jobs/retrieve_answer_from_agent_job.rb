class RetrieveAnswerFromAgentJob < ApplicationJob
  queue_as :default

  def perform(chat_message_id)
    # Do something later
    chat_message = ChatMessage.find(chat_message_id)
    return unless chat_message.role == "user"

    # まずagentからのmessageを作成して新規作成判定にならないようにする
    # see also chat_controller.rb
    agent_message = ChatMessage.create(role: "agent", chat_session_id: chat_message.chat_session_id)
    count = 0
    buffer = ""
    ChatMessageChannel.broadcast_to(chat_message.chat_session, { event: "retrieving_start", content: "", message_id: agent_message.id })
    client = Aws::BedrockAgentRuntime::Client.new
    response = client.retrieve_and_generate_stream(
      input: {
        text: chat_message.content
      },
      retrieve_and_generate_configuration: {
        knowledge_base_configuration: {
          knowledge_base_id: ChatMessage::KNOWLEDGE_BASE_ID,
          model_arn: ChatMessage::MODEL_ARN
        },
        type: "KNOWLEDGE_BASE"
      }
    ) do |stream|
      stream.on_event do |event|
        pp event
        if event.event_type == :output
          buffer += event.text
          if count % 4 == 0
            ChatMessageChannel.broadcast_to(chat_message.chat_session, { event: "retrieving", content: buffer, message_id: agent_message.id })
          end
        end
        count += 1
      end
    end
    ChatMessageChannel.broadcast_to(chat_message.chat_session, { event: "retrieving", content: buffer, message_id: agent_message.id })
    pp response
    agent_message.update(content: buffer)
    ChatMessageChannel.broadcast_to(chat_message.chat_session, { event: "retrieving_end", content: buffer, message_id: agent_message.id })
    pp agent_message
  end
end
