class Message < ApplicationRecord
  belongs_to :threadable, polymorphic: true
  belongs_to :user, optional: true

  validates :body, presence: true

  private

  def broadcast_message
    after_create_commit do
      broadcast_append_to(
        "thread_#{threadable_type}_#{threadable_id}_messages",
        target: "messages",
        partial: "messages/message",
        locals: { message: self, user: user }
      )
    end
  end
end
