class Settings::PreferencesController < Settings::BaseController
  before_action :set_user

  def show; end

  def update
    if @user.update(preferences_params)
      I18n.locale = @user.language.to_sym if @user.language.present?
      session[:locale] = @user.language
      redirect_to settings_preferences_path, notice: t("settings.preferences.saved")
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = Current.user
  end

  def preferences_params
    permitted = [ :language, :currency ]
    permitted << :default_tax if admin_or_owner?
    params.require(:user).permit(*permitted)
  end
end
