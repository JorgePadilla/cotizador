class Settings::OrganizationController < Settings::BaseController
  before_action :set_organization
  before_action :require_admin, only: [ :edit, :update ]

  def show; end

  def edit; end

  def update
    if @organization.update(organization_params)
      redirect_to settings_organization_path, notice: t("settings.organization.messages.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_organization
    @organization = Current.organization
    redirect_to settings_root_path, alert: t("settings.organization.no_organization") if @organization.nil?
  end

  def organization_params
    params.require(:organization).permit(
      :name, :rtn, :nombre_comercial, :casa_matriz_address,
      :address, :phone, :email, :currency, :language
    )
  end
end
