class Settings::FiscalController < Settings::BaseController
  before_action :require_admin

  def show
    @establishments = Current.organization.establishments
                              .includes(emission_points: { cai_authorizations: :document_type })
                              .order(:codigo)
  end

  private

  def set_active_section
    @active_section = :fiscal
  end
end
