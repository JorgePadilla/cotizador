class Sar::EmissionPointsController < Sar::BaseController
  before_action :set_establishment
  before_action :set_emission_point, only: [ :show, :edit, :update, :destroy ]

  def show
    @cai_authorizations = @emission_point.cai_authorizations.includes(:document_type).order(active: :desc, fecha_limite_emision: :desc)
  end

  def new
    @emission_point = @establishment.emission_points.new
  end

  def create
    @emission_point = @establishment.emission_points.new(emission_point_params)
    if @emission_point.save
      redirect_to sar_establishment_emission_point_path(@establishment, @emission_point), notice: t("sar.emission_points.messages.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @emission_point.update(emission_point_params)
      redirect_to sar_establishment_emission_point_path(@establishment, @emission_point), notice: t("sar.emission_points.messages.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @emission_point.destroy
      redirect_to sar_establishment_path(@establishment), notice: t("sar.emission_points.messages.deleted")
    else
      redirect_to sar_establishment_path(@establishment), alert: @emission_point.errors.full_messages.to_sentence
    end
  end

  private

  def set_establishment
    @establishment = current_organization.establishments.find(params[:establishment_id])
  end

  def set_emission_point
    @emission_point = @establishment.emission_points.find(params[:id])
  end

  def emission_point_params
    params.require(:emission_point).permit(:codigo, :descripcion, :active)
  end
end
