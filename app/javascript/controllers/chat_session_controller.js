import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static values = {
    chatSessionId: Number
  }

  static targets = ["messageContentInput", "chatMessages"]

  connect() {
    console.log("chat_session_controller.js loaded")
    console.log(this.chatMessagesTarget)
    consumer.subscriptions.create({channel: "ChatMessageChannel", id: this.chatSessionIdValue}, {
      received: this.streamHandler.bind(this)
    })
  }

  messageSubmitted(event) {
    this.messageContentInputTarget.value = ""
  }

  streamHandler(data) {
    console.info(data)
    if (data.event === "retrieving_start") {
      const template = document.getElementById("chat_message_template")
      const agentMessageElement = template.content.cloneNode(true)
      agentMessageElement.querySelector("turbo-frame").id = `chat_message_${data.message_id}`
      agentMessageElement.querySelector("[data-template='role']").textContent = "agent:"
      agentMessageElement.querySelector("[data-template='content']").textContent = "thinking..."
      this.chatMessagesTarget.appendChild(agentMessageElement)
    } else if (data.event === "retrieving") {
      const chatMessageElement = document.getElementById(`chat_message_${data.message_id}`)
      chatMessageElement.querySelector("[data-template='content']").textContent = data.content
    } else if (data.event === "retrieving_end") {
      const chatMessageElement = document.getElementById(`chat_message_${data.message_id}`)
      chatMessageElement.querySelector("[data-template='content']").textContent = data.content
      chatMessageElement.querySelector("p").classList.remove("text-gray-600")
    }
  }

  // updateResponseFromAgent(data) {}
}
