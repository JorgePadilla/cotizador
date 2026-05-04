class Settings::TeamMembersController < Settings::BaseController
  before_action :require_admin
  before_action :set_user, only: [ :edit, :update ]
  before_action :set_active_team_section

  def index
    @users = scope.order(:email_address)
  end

  def edit
    if cannot_modify_user?(@user)
      redirect_to settings_team_members_path, alert: t("admin_messages.cannot_modify_role")
    end
  end

  def update
    if cannot_modify_user?(@user)
      redirect_to settings_team_members_path, alert: t("admin_messages.cannot_modify_role")
      return
    end

    requested_role = user_params[:role].to_i
    if [ 0, 1, 2 ].include?(requested_role) && !authorized_to_assign_role?(requested_role)
      message = if !Current.user.owner? && requested_role == 0
                  t("admin_messages.cannot_assign_owner")
                else
                  t("admin_messages.not_authorized_role")
                end
      redirect_to settings_team_members_path, alert: message
      return
    end

    if user_params.present? && @user.update(user_params)
      redirect_to settings_team_members_path, notice: t("admin_messages.role_updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_active_team_section
    @active_section = :team_members
  end

  def scope
    if Current.user.owner?
      User.includes(:organization)
    else
      User.where(organization_id: Current.organization&.id).includes(:organization)
    end
  end

  def set_user
    @user = scope.find(params[:id])
  end

  def user_params
    raw = params.require(:user)
    raw.key?(:role) ? { role: raw[:role] } : {}
  end

  def cannot_modify_user?(target_user)
    return false if Current.user&.owner?

    target_user == Current.user || target_user.admin? || target_user.owner?
  end

  def authorized_to_assign_role?(requested_role)
    return false unless [ 0, 1, 2 ].include?(requested_role)

    if Current.user&.owner?
      true
    elsif Current.user&.admin?
      requested_role == 1 || requested_role == 2
    else
      false
    end
  end
end
