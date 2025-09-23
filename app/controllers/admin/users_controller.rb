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

    # Check if user is authorized to assign the requested role
    # Only check for valid roles (0, 1, 2) - invalid roles will be caught by model validation
    requested_role = user_params[:role].to_i
    if [0, 1, 2].include?(requested_role) && !authorized_to_assign_role?(requested_role)
      if !Current.user.owner? && requested_role == 0
        redirect_to admin_users_path, alert: "You cannot assign owner role."
      else
        redirect_to admin_users_path, alert: "You are not authorized to assign this role."
      end
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
    # Use fetch to safely extract parameters with authorization checks in the action
    params.fetch(:user, {}).permit(:role)
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

  def authorized_to_assign_role?(requested_role)
    # Check if the role is valid (0, 1, or 2)
    return false unless [0, 1, 2].include?(requested_role)

    if Current.user&.owner?
      # Owners can assign any valid role
      true
    elsif Current.user&.admin?
      # Admins can only assign admin (1) or member (2) roles
      requested_role == 1 || requested_role == 2
    else
      false
    end
  end
end
