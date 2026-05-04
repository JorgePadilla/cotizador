class Settings::BaseController < ApplicationController
  before_action :require_authentication
  before_action :set_active_section

  layout "settings"

  helper_method :active_section, :admin_or_owner?

  private

  def active_section
    @active_section
  end

  def set_active_section
    @active_section = self.class.name.demodulize.sub("Controller", "").underscore.to_sym
  end

  def admin_or_owner?
    Current.user&.admin? || Current.user&.owner?
  end

  def require_admin
    return if admin_or_owner?

    redirect_to settings_root_path, alert: t("admin_messages.must_be_admin")
  end
end
