class AddEventNameToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :event_name, :string
  end
end
