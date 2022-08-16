class SitesController < ApplicationController
  before_action :set_site, only: %i[update]

  def index
    if params[:query].present?
      @sites = @sites.where('title ILIKE ?', "%#{params[:query]}%")
    end

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: '_search.html.erb', locals: { sites: @sites } }
    end

    @sites = policy_scope(Site).page(params[:page] || 1).per(10)

    @blocked_sites = @sites.where(blocked: true, trust_with_popup: false)
    @trusted_sites = @sites.where(blocked: false, trust_with_popup: true)
    @review_sites = @sites.where(blocked: false, trust_with_popup: false)
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

    if @site.update(site_params)
      redirect_to sites_path, notice: 'Site was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_site
    @site = Site.find(params[:id])
    authorize @site
  end

  def site_params
    params.require(:site).permit(:blocked, :trust_with_popup, :reason, :url)
  end
end
