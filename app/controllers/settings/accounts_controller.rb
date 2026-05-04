class Settings::AccountsController < Settings::BaseController
  before_action :set_user

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      I18n.locale = @user.language.to_sym if @user.language.present?
      redirect_to settings_account_path, notice: t("settings.account.messages.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = Current.user
  end

  def user_params
    params.require(:user).permit(:name, :email_address)
  end
end
