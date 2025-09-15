class ProfilesController < ApplicationController
  # Authentication is already handled by the Authentication module

  # GET /profile
  def show
    @user = Current.user
  end

  # GET /profile/edit
  def edit
    @user = Current.user
  end

  # PATCH/PUT /profile
  def update
    @user = Current.user

    if @user.update(user_params)
      I18n.locale = @user.language.to_sym if @user.language.present?
      flash[:notice] = t("users.messages.profile_updated")
      redirect_to profile_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # PATCH /profile/language
  def update_language
    @user = Current.user

    if @user.update(language_params)
      I18n.locale = @user.language.to_sym
      session[:locale] = @user.language
      flash[:notice] = t("users.messages.language_changed")
      redirect_to profile_path
    else
      redirect_to profile_path, status: :unprocessable_entity
    end
  end

  # PATCH /profile/preferences
  def update_preferences
    @user = Current.user

    if @user.update(preferences_params)
      I18n.locale = @user.language.to_sym
      session[:locale] = @user.language
      flash[:notice] = t("users.messages.profile_updated")
      redirect_to profile_path
    else
      redirect_to profile_path, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email_address, :language, :currency, :default_tax)
  end

  def language_params
    params.require(:user).permit(:language)
  end

  def preferences_params
    params.require(:user).permit(:language, :currency)
  end
end
