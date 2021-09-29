module Api
  module V1
    class NotificationsController < ApplicationController
      before_action :authorize_access_request!
      before_action :set_notification, only: [:show, :update, :destroy]

      # GET /api/v1/notifications
      def index
        @notifications = Notification.select('notifications.action, notifications.status, notifications.id, notifications.event_name, notifications.event_id').where('notifications.recipient_id = ?', current_user.id).order('notifications.id DESC')
        render json: @notifications
      end

      # GET /api/v1/notifications/1
      def show
        render json: @notification
      end

      # POST /api/v1/notifications
      def create
        @notification = Notification.new(notification_params)

        if @notification.save
          render json: @notification, status: :created, location: @notification
        else
          render json: @notification.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/notifications/1
      def update
        if @notification.update(notification_params)
          render json: @notification
        else
          render json: @notification.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/notifications/1
      def destroy
        @notification.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_notification
          @notification = Notification.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def notification_params
          params.require(:notification).permit(:user_id, :event_id, :recipient_id, :action, :status)
        end
    end
end
end