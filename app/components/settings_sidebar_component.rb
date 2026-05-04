class SettingsSidebarComponent < ViewComponent::Base
  def initialize(active_section:, current_user:)
    @active_section = active_section
    @current_user = current_user
  end

  def admin_or_owner?
    @current_user&.admin? || @current_user&.owner?
  end

  def personal_items
    [
      item(:account,     t("settings.sidebar.account"),     helpers.settings_account_path,     "user"),
      item(:preferences, t("settings.sidebar.preferences"), helpers.settings_preferences_path, "sliders")
    ]
  end

  def company_items
    [
      item(:organization, t("settings.sidebar.organization"), helpers.settings_organization_path, "building")
    ]
  end

  def admin_items
    return [] unless admin_or_owner?

    [
      item(:team_members, t("settings.sidebar.team"),    helpers.settings_team_members_path, "users"),
      item(:fiscal,       t("settings.sidebar.fiscal"),  helpers.settings_fiscal_path,       "shield-check")
    ]
  end

  private

  def item(section, label, path, icon)
    { section: section, label: label, path: path, icon: icon, active: section == @active_section }
  end
end
