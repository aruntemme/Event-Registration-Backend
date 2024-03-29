module Api
  module V1
    class EventsController < ApplicationController
      before_action :authorize_access_request!
      before_action :set_event, only: [:show, :update, :destroy]
    

      # GET /api/v1/events
      def index
        if params[:current_user]
          @events = Event.where(user_id: current_user.id).order("id DESC").all
        elsif params[:all]
          @events = Event.order("id DESC").all
        end
        render json: @events,  status: :ok
      end
    
      # GET /api/v1/events/1
      def show
        if @event.video.attached?
          render json: {status: 'success', event: @event, video_url: @event.video.url}
        else
          render json: @event
        end
      end

      # POST /api/v1/events
      def create
        @event = Event.new(event_params)
        @event.user_id = current_user.id
        if @event.save
          render json:  {status: 'success', event: @event, jsonOutput: params[:configurefields]}, status: :created
        else
          render json: @event.errors, status: :unprocessable_entity
        end
      end
    
      # PATCH/PUT /api/v1/events/1
      def update
        if @event.update(event_params)
          
          @registartion = Registration.where("event_id::varchar ILIKE ?", "%#{params[:id]}%")
          @event = Event.where("id::varchar ILIKE ?", "%#{params[:id]}%")
          for registration in @registartion do
            @notification = Notification.new()
            @notification.user_id = current_user.id
            @notification.recipient_id = registration.user_id
            @notification.action = 'updated'
            @notification.status = 'not read'
            @notification.event_id = params[:id]
            @notification.event_name = @event[0].title

            @notification.save
          end

          render json: {status: 'success', event: @event, notification: @notificationstatus, registartion: @registartion}
        else
          render json: @event.errors, status: :unprocessable_entity
        end
      end
    
      # DELETE /api/v1/events/1
      def destroy
        @registration = Registration.where("event_id::varchar ILIKE ?", "%#{params[:id]}%")
        @events = Event.where("id::varchar ILIKE ?", "%#{params[:id]}%")

        for registration in @registration do
          @notification = Notification.new()
          @notification.user_id = current_user.id
          @notification.recipient_id = registration.user_id
          @notification.action = 'deleted'
          @notification.status = 'not read'
          @notification.event_id = params[:id]
          @notification.event_name = @events[0].title
          
          @notification.save
        end
        @event.destroy
        render json: {status: 'success'}
      end
    
      private
        # Use callbacks to share common setup or constraints between actions.
        def set_event
          @event = Event.find(params[:id])
        end
    
        # Only allow a list of trusted parameters through.
        def event_params
          params.require(:event).permit(:title, :description, :fees, :location, :date, :tags, :maxparticipants, :configurefields, :createdby, :video)
        end
    end
  end
end