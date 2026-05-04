class Settings::HomeController < Settings::BaseController
  layout "application"

  def index
    @menu_items = build_menu_items
  end

  private

  def build_menu_items
    items = [
      menu_item(:dashboard,    t("settings.home.items.dashboard"),    helpers.root_path,                   "chart"),
      menu_item(:account,      t("settings.home.items.account"),      helpers.settings_account_path,       "user"),
      menu_item(:preferences,  t("settings.home.items.preferences"),  helpers.settings_preferences_path,   "sliders"),
      menu_item(:organization, t("settings.home.items.organization"), helpers.settings_organization_path,  "building")
    ]
    if admin_or_owner?
      items << menu_item(:team,   t("settings.home.items.team"),   helpers.settings_team_members_path, "users")
      items << menu_item(:fiscal, t("settings.home.items.fiscal"), helpers.settings_fiscal_path,       "shield-check")
    end
    items
  end

  def menu_item(key, label, path, icon)
    { key: key, label: label, path: path, icon: icon }
  end
end
