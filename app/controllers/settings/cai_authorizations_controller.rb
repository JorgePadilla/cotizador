class Settings::CaiAuthorizationsController < Settings::BaseController
  before_action :require_admin
  before_action :set_cai, only: [ :show, :edit, :update, :destroy ]
  before_action :set_active_section_to_fiscal

  def index
    redirect_to settings_fiscal_path
  end

  def show
    redirect_to settings_fiscal_path
  end

  def new
    @cai_authorization = CaiAuthorization.new(emission_point_id: params[:emission_point_id], document_type: DocumentType.invoice)
    load_form_collections
  end

  def create
    @cai_authorization = CaiAuthorization.new(cai_params)
    if scoped_to_org?(@cai_authorization) && @cai_authorization.save
      redirect_to settings_fiscal_path, notice: t("sar.cai_authorizations.messages.created")
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
      redirect_to settings_fiscal_path, notice: t("sar.cai_authorizations.messages.updated")
    else
      load_form_collections
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @cai_authorization.correlativo_actual > 0
      redirect_to settings_fiscal_path, alert: t("sar.cai_authorizations.messages.cannot_delete_used")
      return
    end

    @cai_authorization.destroy
    redirect_to settings_fiscal_path, notice: t("sar.cai_authorizations.messages.deleted")
  end

  private

  def set_active_section_to_fiscal
    @active_section = :fiscal
  end

  def set_cai
    @cai_authorization = CaiAuthorization
                         .joins(emission_point: :establishment)
                         .where(establishments: { organization_id: Current.organization.id })
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
                       .where(establishments: { organization_id: Current.organization.id })
                       .includes(:establishment)
                       .order("establishments.codigo, emission_points.codigo")
    @document_types = DocumentType.order(:code)
  end

  def scoped_to_org?(cai)
    return false if cai.emission_point_id.blank?

    EmissionPoint
      .joins(:establishment)
      .where(establishments: { organization_id: Current.organization.id }, emission_points: { id: cai.emission_point_id })
      .exists?
  end
end
