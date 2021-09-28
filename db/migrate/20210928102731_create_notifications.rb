class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :event_id
      t.integer :recipient_id
      t.string :action
      t.string :status

      t.timestamps
    end
  end
end
