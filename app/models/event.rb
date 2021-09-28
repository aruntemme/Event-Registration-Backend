class Event < ApplicationRecord
  belongs_to :user
  has_many :registrations, dependent: :destroy
  has_many :notifications
  validates :title, :description, :duration, :fees, :tags, :date, :location, :maxparticipants, :createdby, presence: true
  
  validate :json_field_format

  def parsed_json_field
    JSON.parse(configurefields)
  end

  private

  def json_field_format
    return if configurefields.blank?
    begin
      parsed_json_field
    rescue JSON::ParserError => e
      errors[:configurefields] << "is not valid JSON" 
    end
  end
end
