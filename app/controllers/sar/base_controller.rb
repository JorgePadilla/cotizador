class Sar::BaseController < ApplicationController
  before_action :require_admin

  private

  def require_admin
    return if Current.user&.admin? || Current.user&.owner?

    redirect_to root_path, alert: t("admin_messages.must_be_admin")
  end

  def current_organization
    Current.organization
  end
end
