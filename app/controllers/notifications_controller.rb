class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[update]

  def index
    @notifications = policy_scope(Notification).where(read: false).order(accessed_at: :desc)
  end

  def update
    if @notification.update(site_params)
      redirect_to sites_path, notice: 'Notification was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
    authorize @notification
  end

  def notification_params
    params.require(:notification).permit(:read)
  end
end
