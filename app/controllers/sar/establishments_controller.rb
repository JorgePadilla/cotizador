class Sar::EstablishmentsController < Sar::BaseController
  before_action :set_establishment, only: [ :show, :edit, :update, :destroy ]

  def index
    @establishments = current_organization.establishments.order(:codigo)
  end

  def show
    @emission_points = @establishment.emission_points.order(:codigo)
  end

  def new
    @establishment = current_organization.establishments.new
  end

  def create
    @establishment = current_organization.establishments.new(establishment_params)
    if @establishment.save
      redirect_to sar_establishment_path(@establishment), notice: t("sar.establishments.messages.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @establishment.update(establishment_params)
      redirect_to sar_establishment_path(@establishment), notice: t("sar.establishments.messages.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @establishment.destroy
      redirect_to sar_establishments_path, notice: t("sar.establishments.messages.deleted")
    else
      redirect_to sar_establishments_path, alert: @establishment.errors.full_messages.to_sentence
    end
  end

  private

  def set_establishment
    @establishment = current_organization.establishments.find(params[:id])
  end

  def establishment_params
    params.require(:establishment).permit(:codigo, :nombre, :address, :phone, :active)
  end
end
