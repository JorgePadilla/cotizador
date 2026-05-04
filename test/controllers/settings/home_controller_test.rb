require "test_helper"

class Settings::HomeControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated request is redirected to sign in" do
    get settings_root_path
    assert_redirected_to new_session_path
  end

  test "admin sees the full menu including Equipo and Facturación SAR" do
    sign_in_as(users(:admin_user))
    get settings_root_path
    assert_response :success
    assert_match I18n.t("settings.home.items.dashboard"),    response.body
    assert_match I18n.t("settings.home.items.account"),      response.body
    assert_match I18n.t("settings.home.items.preferences"),  response.body
    assert_match I18n.t("settings.home.items.organization"), response.body
    assert_match I18n.t("settings.home.items.team"),         response.body
    assert_match I18n.t("settings.home.items.fiscal"),       response.body
    assert_match I18n.t("settings.home.items.sign_out"),     response.body
  end

  test "member does not see Equipo or Facturación SAR" do
    sign_in_as(users(:member_user))
    get settings_root_path
    assert_response :success
    assert_no_match(/#{I18n.t('settings.home.items.team')}/,   response.body)
    assert_no_match(/#{I18n.t('settings.home.items.fiscal')}/, response.body)
    assert_match I18n.t("settings.home.items.dashboard"),     response.body
    assert_match I18n.t("settings.home.items.sign_out"),      response.body
  end

  test "menu page does not render the settings sidebar" do
    sign_in_as(users(:admin_user))
    get settings_root_path
    assert_no_match(/settings_sidebar_component/, response.body)
  end
end
