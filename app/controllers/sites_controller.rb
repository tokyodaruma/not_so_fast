class SitesController < ApplicationController

  def index
    @sites = policy_scope(Site)
    @blocked_sites = @sites.where(blocked: true)
    @trusted_sites = @sites.where(blocked: false)
  end

  def create
    @notification = Notification.find(params[:notification_id])
    @site = Site.new(site_params)
    @notification.site = @notification
    @site.user = current_user
    if @site.save
      redirect_to sites_path
    else
      render 'notifications/show'
    end
    authorize @site
  end

  def update
    @site = site.find(params[:id])
    if @site.update(site_params)
      redirect_to sites_path
    else
      render 'sites/index'
    end
  end

  private

  def site_params
    params.require(:site).permit(:blocked, :trust_with_popup, :reason)
  end
end
