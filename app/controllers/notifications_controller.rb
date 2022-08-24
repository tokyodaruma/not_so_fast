class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[update]
  before_action :set_site, only: %i[update]
  before_action :notification_params, only: %i[update]
  before_action :site_params, only: %i[update]

  def index
    @notifications = policy_scope(Notification).where(read: false).order(accessed_at: :desc)
    @care_receiver = CareReceiver.new
  end

  def update
    if @notification.update(@notification_params)
      @site.update(site_params)
      redirect_to sites_path, notice: 'Notification was successfully updated.'
    else
      render :index
    end
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
    authorize @notification
  end

  def set_site
    @site = Site.find(params[:site][:site_id])
    authorize @site
  end

  def notification_params
    @notification_params, @site_params = params.require(%i[notification site])
    @notification_params = @notification_params.permit(:read)
  end

  def site_params
    params.require(:site).permit(:status)
  end
end
