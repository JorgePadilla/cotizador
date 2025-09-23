class Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: [ :edit, :update ]

  def index
    @users = User.includes(:organization).order(:email_address)
  end

  def edit
    # Prevent admins from editing their own role or roles of other admins/owners
    if cannot_modify_user?(@user)
      redirect_to admin_users_path, alert: "You cannot modify this user's role."
    end
  end

  def update
    # Prevent admins from changing their own role or roles of other admins/owners
    if cannot_modify_user?(@user)
      redirect_to admin_users_path, alert: "You cannot modify this user's role."
      return
    end

    # Only allow owners to assign owner role, admins can only assign member role
    if !Current.user.owner? && user_params[:role].to_i == 0
      redirect_to admin_users_path, alert: "You cannot assign owner role."
      return
    end

    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User role updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    # Only allow role parameter if user is authorized to assign roles
    permitted_params = []
    permitted_params << :role if Current.user&.owner? || (Current.user&.admin? && params[:user][:role].to_i != 0)

    params.require(:user).permit(*permitted_params)
  end

  def require_admin
    unless Current.user&.admin? || Current.user&.owner?
      redirect_to root_path, alert: "You must be an admin to access this page."
    end
  end

  def cannot_modify_user?(target_user)
    # Owners can modify anyone
    return false if Current.user&.owner?

    # Admins cannot modify:
    # 1. Themselves
    # 2. Other admins
    # 3. Owners
    target_user == Current.user || target_user.admin? || target_user.owner?
  end
end
