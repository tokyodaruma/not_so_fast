class SitesController < ApplicationController
  before_action :set_params, only: %i[update]

  def index
    @sites = policy_scope(Site)
    @blocked_sites = @sites.where(status: :blocked)
    @trusted_sites = @sites.where(status: :trusted)
    @pending_sites = @sites.where(status: :pending)
    @new_site = Site.new
    @notifications = policy_scope(Notification).order(accessed_at: :desc)
  end

  def new
    @site = Site.new

    if @site.save
      redirect_to sites_path, notice: 'Site was successfully created.'
    else
      render :new
    end
    authorize @site
  end

  # POST /sites
  def create
    @notification = Notification.find(params[:notification_id])
    @site = Site.new(site_params)
    @site.notification = @notification
    @site.user = current_user

    # Twilio call
    if @site.save
      SendSmsService.new('WARNING: Security Alert for Grandma has been activated.
        Check your NotSoFast app for more information.').call
      redirect_to "/"
    else
      @errors = @user.errors.full_messages
    end
    authorize @site
  end

  def edit
  end

  # PATCH/PUT /sites/1
  def update
    @site = Site.find(params[:id])
    # updating read status on notifications#index
    if @site.update(@site_params) && params.include?("notification")
      @notification = Notification.find(params[:id])
      @notification.update(@notification_params)
      redirect_to sites_path, notice: 'Site was successfully updated.'
    # updating site#index block/unblock
    elsif @site.update(@site_params)
      authorize @site
      redirect_to sites_path, notice: 'Site was successfully updated.'
    else
      render :edit
    end
  end

  private

  # def set_site
  #   @site = Site.find(params[:id])
  #   @notification = Notification.find(params[:id])
  #   authorize @site
  #   authorize @notification
  # end

  def set_params
    if params.include?("site") && !params.include?("notification")
      @site_params = params.require(:site).permit(:url,
                                                  :reason,
                                                  :referral_site,
                                                  :notification_id,
                                                  :detections,
                                                  :risk_score,
                                                  :status,
                                                  :is_domain_recent,
                                                  :webpage_title)
    else
      @notification_params, @site_params = params.require(%i[notification site])
      @notification_params = @notification_params.permit(:read)
    end
  end
end
