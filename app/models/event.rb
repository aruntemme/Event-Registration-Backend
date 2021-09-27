class Event < ApplicationRecord
  belongs_to :user
  has_many :registrations, dependent: :destroy
  validates :title, :description, :duration, :fees, :tags, :date, :location, :maxparticipants,:configurefields, :createdby, presence: true
end
