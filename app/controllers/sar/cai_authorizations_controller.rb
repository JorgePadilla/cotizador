class Sar::CaiAuthorizationsController < Sar::BaseController
  before_action :set_cai, only: [ :show, :edit, :update, :destroy ]

  def index
    @cai_authorizations = CaiAuthorization
                          .joins(emission_point: :establishment)
                          .where(establishments: { organization_id: current_organization.id })
                          .includes(:document_type, emission_point: :establishment)
                          .order("establishments.codigo, emission_points.codigo, document_types.code, fecha_limite_emision DESC")
  end

  def show; end

  def new
    @cai_authorization = CaiAuthorization.new
    load_form_collections
  end

  def create
    @cai_authorization = CaiAuthorization.new(cai_params)
    if scoped_to_org?(@cai_authorization) && @cai_authorization.save
      redirect_to sar_cai_authorization_path(@cai_authorization), notice: t("sar.cai_authorizations.messages.created")
    else
      load_form_collections
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    load_form_collections
  end

  def update
    if @cai_authorization.update(cai_params)
      redirect_to sar_cai_authorization_path(@cai_authorization), notice: t("sar.cai_authorizations.messages.updated")
    else
      load_form_collections
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @cai_authorization.correlativo_actual > 0
      redirect_to sar_cai_authorization_path(@cai_authorization),
                  alert: t("sar.cai_authorizations.messages.cannot_delete_used")
      return
    end

    @cai_authorization.destroy
    redirect_to sar_cai_authorizations_path, notice: t("sar.cai_authorizations.messages.deleted")
  end

  private

  def set_cai
    @cai_authorization = CaiAuthorization
                         .joins(emission_point: :establishment)
                         .where(establishments: { organization_id: current_organization.id })
                         .find(params[:id])
  end

  def cai_params
    params.require(:cai_authorization).permit(
      :emission_point_id, :document_type_id, :cai,
      :rango_inicial, :rango_final, :fecha_limite_emision,
      :fecha_resolucion, :numero_resolucion, :active
    )
  end

  def load_form_collections
    @emission_points = EmissionPoint
                       .joins(:establishment)
                       .where(establishments: { organization_id: current_organization.id })
                       .includes(:establishment)
                       .order("establishments.codigo, emission_points.codigo")
    @document_types = DocumentType.order(:code)
  end

  def scoped_to_org?(cai)
    return false if cai.emission_point_id.blank?

    EmissionPoint
      .joins(:establishment)
      .where(establishments: { organization_id: current_organization.id }, emission_points: { id: cai.emission_point_id })
      .exists?
  end
end
