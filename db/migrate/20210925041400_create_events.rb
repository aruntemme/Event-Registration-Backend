class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.integer :duration
      t.integer :fees
      t.string :tags
      t.integer :maxparticipants
      t.string :createdby
      t.string :configurefields
      t.timestamp :date
      t.string :location
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
