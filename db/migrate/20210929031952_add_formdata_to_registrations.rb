class AddFormdataToRegistrations < ActiveRecord::Migration[6.1]
  def change
    add_column :registrations, :formdata, :json
  end
end
