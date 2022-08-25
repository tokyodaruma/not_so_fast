class Api::V1::NotificationsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: %i[index]
  before_action :set_notification, only: %i[update]
  before_action :set_params, only: %i[create]

  def index
    @notifications = policy_scope(Notification)
  end

  def update
    if @notification.update(@notification_params)
      render :index
    else
      render_error
    end
  end

  def create
    @notification = Notification.new(@notification_params)
    @notification.user = current_user
    @site = Site.new(@site_params)
    @site.notification = @notification
    @site.user = current_user
    authorize @notification
    if @notification.save
      @site.save
      SendSmsService.new("NotSoFast: Care receiver accessed '#{@site.url}' which was flagged as suspicious.
        Check your dashboard to review this site.").call
      render :index, status: :created
    else
      render_error
    end
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
    authorize @notification
  end

  def set_params
    @notification_params, @site_params = params.require(%i[notification site])
    @notification_params = @notification_params.permit(:accessed_at, :description, :read)
    @site_params = @site_params.permit(:url,
                                       :reason,
                                       :referral_site,
                                       :notification_id,
                                       :detections,
                                       :risk_score,
                                       :status,
                                       :is_domain_recent,
                                       :webpage_title)
  end

  def render_error
    render json: { errors: @notification.errors.full_messages },
      status: :unprocessable_entity
  end
end
