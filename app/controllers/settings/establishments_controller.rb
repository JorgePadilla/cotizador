class Settings::EstablishmentsController < Settings::BaseController
  before_action :require_admin
  before_action :set_establishment, only: [ :show, :edit, :update, :destroy ]
  before_action :set_active_section_to_fiscal

  def index
    redirect_to settings_fiscal_path
  end

  def show
    redirect_to settings_fiscal_path
  end

  def new
    @establishment = Current.organization.establishments.new
  end

  def create
    @establishment = Current.organization.establishments.new(establishment_params)
    if @establishment.save
      redirect_to settings_fiscal_path, notice: t("sar.establishments.messages.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @establishment.update(establishment_params)
      redirect_to settings_fiscal_path, notice: t("sar.establishments.messages.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @establishment.destroy
      redirect_to settings_fiscal_path, notice: t("sar.establishments.messages.deleted")
    else
      redirect_to settings_fiscal_path, alert: @establishment.errors.full_messages.to_sentence
    end
  end

  private

  def set_active_section_to_fiscal
    @active_section = :fiscal
  end

  def set_establishment
    @establishment = Current.organization.establishments.find(params[:id])
  end

  def establishment_params
    params.require(:establishment).permit(:codigo, :nombre, :address, :phone, :active)
  end
end
