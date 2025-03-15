class ChatMessage < ApplicationRecord
  belongs_to :chat_session

  KNOWLEDGE_BASE_ID = ENV["AWS_BEDROCK_KNOWLEDGE_BASE_ID"]
  # MODEL_ARN = "amazon.nova-pro-v1:0"
  MODEL_ARN = "anthropic.claude-3-5-sonnet-20240620-v1:0"
end
