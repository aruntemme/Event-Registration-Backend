class Registration < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :event_id, :formdata, presence: true 
end