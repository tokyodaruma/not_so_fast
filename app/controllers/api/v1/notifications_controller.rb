class Api::V1::NotificationsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: %i[index]
  before_action :set_notification, only: %i[update]

  def index
    @notifications = policy_scope(Notification)
  end

  def update
    if @notification.update(notification_params)
      render :index
    else
      render_error
    end
  end

  def create
    @notification = Notification.new(notification_params)
    @notification.user = current_user
    authorize @notification
    if @notification.save
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

  def notification_params
    params.require(:notification).permit(:accessed_at, :description, :read)
  end

  def render_error
    render json: { errors: @notification.errors.full_messages },
      status: :unprocessable_entity
  end
end
