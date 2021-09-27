module Api
  module V1
    class EventsController < ApplicationController
      before_action :authorize_access_request!
      before_action :set_event, only: [:show, :update, :destroy]
    

      # GET /events
      def index
        if params[:current_user]
          @events = Event.where(user_id: current_user.id).order("id DESC").all
        elsif params[:all]
          @events = Event.order("id DESC").all
        end
        render json: @events,  status: :ok
      end
    
      # GET /events/1
      def show
        render json: @event
      end

      # POST /events
      def create
        @event = Event.new(event_params)
        @event.user_id = current_user.id
        if @event.save
          render json:  {status: 'success', event: @event}, status: :created
        else
          render json: @event.errors, status: :unprocessable_entity
        end
      end
    
      # PATCH/PUT /events/1
      def update
        if @event.update(event_params)
          render json: {status: 'success', event: @event}
        else
          render json: @event.errors, status: :unprocessable_entity
        end
      end
    
      # DELETE /events/1
      def destroy
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
          params.require(:event).permit(:title, :description, :duration, :fees, :location, :date, :tags, :maxparticipants, :configurefields, :createdby)
        end
    end
  end
end