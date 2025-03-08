class CreateChatSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_sessions do |t|
      t.string :title, null: false
      t.string :bedrock_session_id, null: false
      t.timestamps
    end
  end
end
