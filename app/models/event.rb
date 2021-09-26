class Event < ApplicationRecord
  
  validates :title, :description, :duration, :fees, :tags, :date, :location, :maxparticipants,:configurefields, :createdby, presence: true
end
