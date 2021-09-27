module Api
  module V1
class RegistrationsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_event, only: [:create, :show, :update, :destroy]

  # GET /api/v1/registrations
  def index
    # GET registered events for current_user
    if params[:current_user]
      @registrations =  Event.joins(:registrations).where(Registration.arel_table[:user_id].matches(current_user.id))

    # GET all registered events
    elsif params[:event_id]
      @registrations =  Event.joins(:registrations).where(Registration.arel_table[:event_id].matches(params[:event_id]))
      if @registrations[0].id == params[:event_id]
        @registrations = {status: 'success'}
      end
    else
      @registrations = Event.joins(:registrations).all
    end
    
    render json: @registrations, status: :ok
  end

  def new
    @registration = @event.registrations.new
  end

  # GET /api/v1/registrations/1
  def show
    @registration = @event.registrations.find(params[:id])

    render json: @registration
  end

  # POST /api/v1/registrations
  def create
    @registration = @event.registrations.new(registration_params)
    @registration.user = current_user
    if @registration.save
      @event.decrement :maxparticipants, 1
      @event.update(maxparticipants: @event.maxparticipants)
      render json:  {status: 'success', event: @event, registration: @registration}, status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:event_id])
    end

    # Only allow a list of trusted parameters through.
    def registration_params
      params.require(:registration).permit(:event_id)
    end
end
end
end