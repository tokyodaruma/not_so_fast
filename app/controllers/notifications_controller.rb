class NotificationsController < ApplicationController
  def index
    @notifications = policy_scope(Notification).order(accessed_at: :desc)
  end
end
