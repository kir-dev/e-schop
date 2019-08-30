class CreateConversations < ActiveRecord::Migration[5.2]
  def change
    create_table :conversations do |t|
      t.integer :receiver_id
      t.integer :sender_id

      t.timestamps
    end
  end
end
