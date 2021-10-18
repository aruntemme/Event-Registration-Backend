class Event < ApplicationRecord
  belongs_to :user
  has_many :registrations, dependent: :destroy
  has_many :notifications
  has_one_attached :video
  validates :title, :description, :fees, :tags, :date, :location, :maxparticipants, :createdby, presence: true
  
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
