class Settings::EmissionPointsController < Settings::BaseController
  before_action :require_admin
  before_action :set_establishment
  before_action :set_emission_point, only: [ :show, :edit, :update, :destroy ]
  before_action :set_active_section_to_fiscal

  def show
    redirect_to settings_fiscal_path
  end

  def new
    @emission_point = @establishment.emission_points.new
  end

  def create
    @emission_point = @establishment.emission_points.new(emission_point_params)
    if @emission_point.save
      redirect_to settings_fiscal_path, notice: t("sar.emission_points.messages.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @emission_point.update(emission_point_params)
      redirect_to settings_fiscal_path, notice: t("sar.emission_points.messages.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @emission_point.destroy
      redirect_to settings_fiscal_path, notice: t("sar.emission_points.messages.deleted")
    else
      redirect_to settings_fiscal_path, alert: @emission_point.errors.full_messages.to_sentence
    end
  end

  private

  def set_active_section_to_fiscal
    @active_section = :fiscal
  end

  def set_establishment
    @establishment = Current.organization.establishments.find(params[:establishment_id])
  end

  def set_emission_point
    @emission_point = @establishment.emission_points.find(params[:id])
  end

  def emission_point_params
    params.require(:emission_point).permit(:codigo, :descripcion, :active)
  end
end
