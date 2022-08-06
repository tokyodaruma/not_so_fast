class NotificationsController < ApplicationController
  def index
    @notifications = policy_scope(Notification).order(created_at: :desc)
  end
end
